require 'bundler/setup'
require 'uv'

# In c style
loop = UV.default_loop

tcp = UV::Tcp.new

UV.tcp_init(loop, tcp)

binding.pry
