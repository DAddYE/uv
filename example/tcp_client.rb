require 'bundler/setup'
require 'uv'
require 'fiber'

LOOP = UV.default_loop
CALLBACK = {}

# Helpers
def refute_error(error_code)
  return if error_code.nil?
  return if error_code >= 0
  err = LOOP.lookup_error(error_code)
  return if !err
  raise RuntimeError, err, caller
end

def assert_kind_of(type, actual)
  return if actual.kind_of?(type)
  msg = "value #{actual.inspect} is not a valid #{type}"
  raise ArgumentError, msg, caller
end

def callback(name, &block)
  fiber = Fiber.current
  name  = "#{name}:#{object_id}"
  CALLBACK[name] ||= ->(*args) do
    begin
      block[args] if block
    ensure
      fiber.resume(*args)
      CALLBACK.delete(name)
    end
  end
  CALLBACK[name]
end

# Fiber methods
def connect(client)
  addr = UV.ip4_addr('127.0.0.1', 4150)
  err = UV.tcp_connect(UV::Connect.new, client, addr, callback(:connect_cb))
  refute_error(err)

  Fiber.yield
end

def write(req, text)
  assert_kind_of(UV::Connect, req)
  assert_kind_of(UV::Stream, req[:handle])

  buf = UV.buf_init(text, text.bytesize)
  err = UV.write(UV::Write.new, req[:handle], buf, 1, callback(:write_cb))
  refute_error(err)

  Fiber.yield
end

def read(req)
  assert_kind_of(UV::Write, req)
  assert_kind_of(UV::Stream, req[:handle])

  alloc_cb = CALLBACK[:alloc_cb] = ->(handle, size){ UV.buff_init('', size) }
  err = UV.read_start(req[:handle], alloc_cb, callback(:read_cb))
  refute_error(err)

  Fiber.yield
end

Fiber.new do
  # Initialization
  client = UV::Tcp.new
  err = UV.tcp_init(LOOP, client)
  refute_error(err)

  # Open connection
  req, s = connect(client)
  raise 'Error with connection' if s == -1

  # Start writing
  write_req, s = write(req, 'hello')
  raise 'Error with write' if s == -1

  # Read the response
  stream, nread, buf = read(write_req)
  check_error(nread)
  p stream, nread, buf[:base]
end.
resume

# RUN
err = UV.run(LOOP, :uv_run_default)
refute_error(err)
