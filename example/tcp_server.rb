require 'bundler/setup'
require_relative './helpers'
require 'uv'

LOOP = UV.default_loop

async def listen(server)
  assert_kind_of(UV::Tcp, server)

  # Create an ip4 address
  addr = UV::SockaddrIn.new
  err = UV.ip4_addr('127.0.0.1', 4150, addr)
  refute_error(err)

  # Now we can bind the server to that address
  err = UV.tcp_bind(server, addr, 0)
  refute_error(err)

  # Finally we can listen the stream
  stream = UV::Stream.new(server.to_ptr)
  err = UV.listen(stream, 128, resume)
  refute_error(err)
end

# or in this way
async def read(req)
  assert_kind_of(UV::Stream, req)

  # This block *resume* the async call
  read_cb = resume do |stream, nread, buf|
    text = nread > 0 ? buf[:base].read_string(nread) : ''
    UV.free(buf[:base])
    [stream, nread, text]
  end

  # This is just a plain callback
  alloc_cb = ->(_, size, buf) do
    buf[:len] = size
    buf[:base] = UV.malloc(size)
  end

  # We shouldn't need to take care of GC here since both callbacks are used now.
  err = UV.read_start(req, alloc_cb, read_cb)
  refute_error(err)
end

async def close(req)
  UV.close(UV::Handle.new(req.to_ptr), resume)
end

async def write(req, text)
  assert_kind_of(UV::Stream, req)

  buf = UV.buf_init(text, text.bytesize)
  err = UV.write(UV::Write.new, req, buf, 1, resume)
  refute_error(err)
end

sync do
  # Setup the server
  server = UV::Tcp.new
  err = UV.tcp_init(LOOP, server)
  refute_error(err)

  # Start Listening
  server_stream, err = listen(server)
  refute_error(err)

  # Setup the client
  client = UV::Tcp.new
  err = UV.tcp_init(LOOP, client)
  refute_error(err)

  # Accept requests
  client_stream = UV::Stream.new(client.to_ptr)
  err = UV.accept(server_stream, client_stream)
  refute_error(err)

  # Start echo-ing
  loop do
    # Read from the client stream
    _, err, buf = read(client_stream)
    refute_error(err)
    puts buf

    # Write what we got on the same stream
    _, err = write(client_stream, buf)
    refute_error(err)

    # If we receive `quit` then we can close
    if buf == "quit\n"
      close(client)
      close(server)
      break
    end
  end
end

# Trap interupt
uv_trap(LOOP, :INT){ |_, n| UV.stop(LOOP) }

# RUN
err = UV.run(LOOP, :uv_run_default)
refute_error(err)
