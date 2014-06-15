require 'bundler/setup'
require 'uv'

# In c style

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
addr = UV.ip4_addr('127.0.0.1', 4150)
req = UV::Connect.new
err = UV.tcp_connect(req, client, addr){ |r, s| p 'connected with status %d' % s; r }
refute_error(loop, err)

# RUN
err = UV.run(loop, :uv_run_default)
refute_error(loop, err)
