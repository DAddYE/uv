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
    text = buf[:base].read_string(nread)
    UV.free(buf[:base])
    f.resume(stream, nread, text)
  end

  alloc_cb = ->(handle, size, buf) do
    buf[:len] = size
    buf[:base] = UV.malloc(size)
  end

  err = UV.read_start(req, alloc_cb, read_cb)
  refute_error(err)

  wait
end

def close(request)
  UV.close(UV::Handle.new(request.to_ptr), resume)
  wait
end

Fiber.new do
  server = UV::Tcp.new
  err = UV.tcp_init(LOOP, server)
  refute_error(err)
  server_stream, err = listen(server)
  refute_error(err)

  client = UV::Tcp.new
  client_stream = UV::Stream.new(client.to_ptr)
  err = UV.tcp_init(LOOP, client)
  refute_error(err)

  err = UV.accept(server_stream, client_stream)
  refute_error(err)

  loop do
    stream, nread, buf = read(client_stream)
    refute_error(nread)
    puts buf
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
