require 'bundler/setup'
require 'uv'
require 'fiber'

def refute_error(loop, error_code)
  return if error_code.nil?
  return if error_code == 0
  err = loop.lookup_error(error_code)
  raise err if err
end

# Initialization
loop = UV.default_loop
client = UV::Tcp.new
err = UV.tcp_init(loop, client)
refute_error(loop, err)

# Connect
# addr = UV.ip4_addr('127.0.0.1', 4150)
# req = UV::Connect.new
# err = UV.tcp_connect(req, client, addr){ |r, s| p 'connected with status %d' % s; r }
# refute_error(loop, err)

def connect(loop, client)
  f = Fiber.current
  addr = UV.ip4_addr('127.0.0.1', 4150)
  req = UV::Connect.new
  err = UV.tcp_connect(req, client, addr){ |r, s| f.resume(r, s); r }
  refute_error(loop, err)
  Fiber.yield
end

Fiber.new do
  r, s = connect(loop, client)
  p r, s
end.
resume

# RUN
err = UV.run(loop, :uv_run_default)
refute_error(loop, err)
