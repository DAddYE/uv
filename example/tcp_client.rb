require_relative './helpers'

LOOP = UV.default_loop

# Fiber methods
async \
def connect(client)
  assert_kind_of(UV::Tcp, client)

  addr = UV::SockaddrIn.new
  err = UV.ip4_addr('127.0.0.1', 4150, addr)
  refute_error(err)

  err = UV.tcp_connect(UV::Connect.new, client, addr, resume)
  refute_error(err)
end

async \
def write(req, text)
  assert_kind_of(UV::Connect, req)
  assert_kind_of(UV::Stream, req[:handle])

  buf = UV.buf_init(text, text.bytesize)
  err = UV.write(UV::Write.new, req[:handle], buf, 1, resume)
  refute_error(err)
end

async \
def read(req)
  assert_kind_of(UV::Stream, req[:handle])

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
    buf
  end

  err = UV.read_start(req[:handle], alloc_cb, read_cb)
  refute_error(err)
end

sync do
  log 'Initialization'
  client = UV::Tcp.new
  err = UV.tcp_init(LOOP, client)
  refute_error(err)

  log 'Open connection'
  connect_req, s = connect(client)
  raise 'Error with connection' if s == -1

  log 'Start writing'
  write_req, err = write(connect_req, "hello\n")
  refute_error(err)

  log 'Read the response'
  _, err, buf = read(write_req)
  refute_error(err)
  puts buf

  log 'Ask to close the close'
  _, err = write(connect_req, "quit\n")
  refute_error(err)
end

# Trap interupt
uv_trap(LOOP, :INT){ |_, n| UV.stop(LOOP) }

# RUN
err = UV.run(LOOP, :uv_run_default)
refute_error(err)
