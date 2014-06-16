require 'bundler/setup'
require_relative './helpers'
require 'uv'

LOOP = UV.default_loop

# Fiber methods
def connect(client)
  assert_kind_of(Tcp, srv)

  addr = UV::SockaddrIn.new
  err = UV.ip4_addr('127.0.0.1', 4150, addr)
  refute_error(err)

  err = UV.tcp_connect(UV::Connect.new, client, addr, resume)
  refute_error(err)

  wait
end

def write(req, text)
  assert_kind_of(UV::Connect, req)
  assert_kind_of(UV::Stream, req[:handle])

  buf = UV.buf_init(text, text.bytesize)
  err = UV.write(UV::Write.new, req[:handle], buf, 1, resume)
  refute_error(err)

  wait
end

def read(req)
  assert_kind_of(UV::Stream, req[:handle])

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

  err = UV.read_start(req[:handle], alloc_cb, read_cb)
  refute_error(err)

  wait
end

Fiber.new do
  # Initialization
  client = UV::Tcp.new
  err = UV.tcp_init(LOOP, client)
  refute_error(err)

  # Open connection
  connect_req, s = connect(client)
  raise 'Error with connection' if s == -1

  # Start writing
  write_req, s = write(connect_req, 'hello')
  raise 'Error with write' if s == -1

  # Read the response
  stream, nread, buf = read(write_req)
  refute_error(nread)
end.
resume

# RUN
err = UV.run(LOOP, :uv_run_default)
refute_error(err)
