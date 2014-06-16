require 'bundler/setup'
require_relative './helpers'
require 'uv'

LOOP = UV.default_loop

def listen(server)
  assert_kind_of(UV::Tcp, server)

  addr = UV::SockaddrIn.new
  err = UV.ip4_addr('127.0.0.1', 4150, addr)
  refute_error(err)

  err = UV.tcp_bind(server, addr, 0)
  refute_error(err)

  stream = UV::Stream.new(server.to_ptr)
  err = UV.listen(stream, 128, resume)
  refute_error(err)

  wait
end

def read(req)
  assert_kind_of(UV::Stream, req)

  f = Fiber.current

  read_cb = ->(stream, nread, buf) do
    text = nread > 0 ? buf[:base].read_string(nread) : ''
    UV.free(buf[:base])
    f.resume(stream, nread, text) if f.alive?
  end

  alloc_cb = ->(handle, size, buf) do
    buf[:len] = size
    buf[:base] = UV.malloc(size)
  end

  err = UV.read_start(req, alloc_cb, read_cb)
  refute_error(err)

  wait
end

def close(req)
  UV.close(UV::Handle.new(req.to_ptr), resume)
  wait
end

def write(req, text)
  assert_kind_of(UV::Stream, req)

  buf = UV.buf_init(text, text.bytesize)
  err = UV.write(UV::Write.new, req, buf, 1, resume)
  refute_error(err)

  wait
end


Fiber.new do
  # Initialize the server
  server = UV::Tcp.new
  err = UV.tcp_init(LOOP, server)
  refute_error(err)
  server_stream, err = listen(server)
  refute_error(err)

  # Setup a listener
  client = UV::Tcp.new
  client_stream = UV::Stream.new(client.to_ptr)
  err = UV.tcp_init(LOOP, client)
  refute_error(err)

  # Accept requests
  err = UV.accept(server_stream, client_stream)
  refute_error(err)

  # Start echo-ing
  loop do
    _, err, buf = read(client_stream)
    refute_error(err)
    puts buf

    _, err = write(client_stream, buf)
    refute_error(err)

    # If we recive `quit` then we can close
    if buf == "quit\n"
      close(client)
      close(server)
      break
    end
  end
end.
resume

# RUN
err = UV.run(LOOP, :uv_run_default)
refute_error(err)
