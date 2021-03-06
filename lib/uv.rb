require 'ffi'
require 'uv/enums'
require 'uv/sockaddr_in'

module UV
  extend FFI::Library
  ffi_lib File.join(__dir__, "../ext/build/lib/libuv.#{FFI::Platform::LIBSUFFIX}")

  autoload :Io, 'uv/io'
  autoload :Async, 'uv/async'
  autoload :Work, 'uv/work'
  autoload :Buf, 'uv/buf'
  autoload :Barrier, 'uv/barrier'
  autoload :Lib, 'uv/lib'
  autoload :Timespec, 'uv/timespec'
  autoload :Stat, 'uv/stat'
  autoload :Req, 'uv/req'
  autoload :Shutdown, 'uv/shutdown'
  autoload :Handle, 'uv/handle'
  autoload :Stream, 'uv/stream'
  autoload :Write, 'uv/write'
  autoload :Tcp, 'uv/tcp'
  autoload :Connect, 'uv/connect'
  autoload :Udp, 'uv/udp'
  autoload :UdpSend, 'uv/udp_send'
  autoload :Tty, 'uv/tty'
  autoload :Pipe, 'uv/pipe'
  autoload :Poll, 'uv/poll'
  autoload :Prepare, 'uv/prepare'
  autoload :Check, 'uv/check'
  autoload :Idle, 'uv/idle'
  autoload :Async, 'uv/async'
  autoload :Timer, 'uv/timer'
  autoload :Getaddrinfo, 'uv/getaddrinfo'
  autoload :StdioContainerData, 'uv/stdio_container_data'
  autoload :StdioContainer, 'uv/stdio_container'
  autoload :ProcessOptions, 'uv/process_options'
  autoload :Process, 'uv/process'
  autoload :Work, 'uv/work'
  autoload :CpuTimes, 'uv/cpu_times'
  autoload :CpuInfo, 'uv/cpu_info'
  autoload :InterfaceAddressAddress, 'uv/interface_address_address'
  autoload :InterfaceAddressNetmask, 'uv/interface_address_netmask'
  autoload :InterfaceAddress, 'uv/interface_address'
  autoload :Timeval, 'uv/timeval'
  autoload :Rusage, 'uv/rusage'
  autoload :Fs, 'uv/fs'
  autoload :FsEvent, 'uv/fs_event'
  autoload :FsPoll, 'uv/fs_poll'
  autoload :SignalTreeEntry, 'uv/signal_tree_entry'
  autoload :Signal, 'uv/signal'
  autoload :AnyHandle, 'uv/any_handle'
  autoload :AnyReq, 'uv/any_req'
  autoload :LoopTimerHeap, 'uv/loop_timer_heap'
  autoload :Loop, 'uv/loop'

  # Make some alias so we can parse without circular dependencies problems.
  typedef :pointer, :io_cb
  typedef :pointer, :close_cb
  typedef :pointer, :async_cb
  typedef :pointer, :timer_cb
  typedef :pointer, :signal_cb
  typedef :pointer, :connect_cb
  typedef :pointer, :read_cb
  typedef :pointer, :read2_cb
  typedef :pointer, :connection_cb
  typedef :pointer, :shutdown_cb
  typedef :pointer, :write_cb
  typedef :pointer, :poll_cb
  typedef :pointer, :prepare_cb
  typedef :pointer, :check_cb
  typedef :pointer, :exit_cb
  typedef :pointer, :process_cb
  typedef :pointer, :idle_cb
  typedef :pointer, :fs_cb
  typedef :pointer, :getaddrinfo_cb
  typedef :pointer, :fs_event_cb
  typedef :pointer, :udp_recv_cb
  typedef :pointer, :udp_send_cb

  typedef :pointer, :unknown

  typedef SockaddrIn.by_ref, :sockaddr_in
  typedef SockaddrIn6.by_ref, :sockaddr_in6

  def self.attach_function(name, func, args, returns = nil, options = {})
    options.merge!(blocking: true) unless options.has_key?(:blocking)
    super(name, func, args, returns, options)
  end

  attach_function :malloc, [:size_t], :pointer
  attach_function :free, [:pointer], :void

  # (Not documented)
  #
  # @method `callback_io_cb`(loop, w, events)
  # @param [Loop] loop
  # @param [Io] w
  # @param [Integer] events
  # @return [nil]
  # @scope class
  #
  callback :io_cb, [Loop.by_ref, Io.by_ref, :uint], :void

  # (Not documented)
  #
  # @method `callback_async_cb`(loop, w, nevents)
  # @param [Loop] loop
  # @param [Async] w
  # @param [Integer] nevents
  # @return [nil]
  # @scope class
  #
  callback :async_cb, [Loop.by_ref, Async.by_ref, :uint], :void

  # Should prepare a buffer that libuv can use to read data into.
  #
  # `suggested_size` is a hint. Returning a buffer that is smaller is perfectly
  # okay as long as `buf.len > 0`.
  #
  # If you return a buffer with `buf.len == 0`, libuv skips the read and calls
  # your read or recv callback with nread=UV_ENOBUFS.
  #
  # Note that returning a zero-length buffer does not stop the handle, call
  # uv_read_stop() or uv_udp_recv_stop() for that.
  #
  # @method `callback_alloc_cb`(handle, suggested_size, buf)
  # @param [Handle] handle
  # @param [Integer] suggested_size
  # @param [Buf] buf
  # @return [nil]
  # @scope class
  #
  callback :alloc_cb, [Handle.by_ref, :ulong, Buf.by_ref], :void

  # `nread` is > 0 if there is data available, 0 if libuv is done reading for
  # now, or < 0 on error.
  #
  # The callee is responsible for closing the stream when an error happens.
  # Trying to read from the stream again is undefined.
  #
  # The callee is responsible for freeing the buffer, libuv does not reuse it.
  # The buffer may be a null buffer (where buf->base=NULL and buf->len=0) on
  # EOF or error.
  #
  # @method `callback_read_cb`(stream, nread, buf)
  # @param [Stream] stream
  # @param [Integer] nread
  # @param [Buf] buf
  # @return [nil]
  # @scope class
  #
  callback :read_cb, [Stream.by_ref, :long, Buf.by_ref], :void

  # (Not documented)
  #
  # @method `callback_write_cb`(req, status)
  # @param [Write] req
  # @param [Integer] status
  # @return [nil]
  # @scope class
  #
  callback :write_cb, [Write.by_ref, :int], :void

  # (Not documented)
  #
  # @method `callback_connect_cb`(req, status)
  # @param [Connect] req
  # @param [Integer] status
  # @return [nil]
  # @scope class
  #
  callback :connect_cb, [Connect.by_ref, :int], :void

  # (Not documented)
  #
  # @method `callback_shutdown_cb`(req, status)
  # @param [Shutdown] req
  # @param [Integer] status
  # @return [nil]
  # @scope class
  #
  callback :shutdown_cb, [Shutdown.by_ref, :int], :void

  # (Not documented)
  #
  # @method `callback_connection_cb`(server, status)
  # @param [Stream] server
  # @param [Integer] status
  # @return [nil]
  # @scope class
  #
  callback :connection_cb, [Stream.by_ref, :int], :void

  # (Not documented)
  #
  # @method `callback_close_cb`(handle)
  # @param [Handle] handle
  # @return [nil]
  # @scope class
  #
  callback :close_cb, [Handle.by_ref], :void

  # (Not documented)
  #
  # @method `callback_poll_cb`(handle, status, events)
  # @param [Poll] handle
  # @param [Integer] status
  # @param [Integer] events
  # @return [nil]
  # @scope class
  #
  callback :poll_cb, [Poll.by_ref, :int, :int], :void

  # (Not documented)
  #
  # @method `callback_timer_cb`(handle)
  # @param [Timer] handle
  # @return [nil]
  # @scope class
  #
  callback :timer_cb, [Timer.by_ref], :void

  # (Not documented)
  #
  # @method `callback_async_cb`(handle)
  # @param [Async] handle
  # @return [nil]
  # @scope class
  #
  callback :async_cb, [Async.by_ref], :void

  # (Not documented)
  #
  # @method `callback_prepare_cb`(handle)
  # @param [Prepare] handle
  # @return [nil]
  # @scope class
  #
  callback :prepare_cb, [Prepare.by_ref], :void

  # (Not documented)
  #
  # @method `callback_check_cb`(handle)
  # @param [Check] handle
  # @return [nil]
  # @scope class
  #
  callback :check_cb, [Check.by_ref], :void

  # (Not documented)
  #
  # @method `callback_idle_cb`(handle)
  # @param [Idle] handle
  # @return [nil]
  # @scope class
  #
  callback :idle_cb, [Idle.by_ref], :void

  # (Not documented)
  #
  # @method `callback_exit_cb`(, exit_status, term_signal)
  # @param [Process]
  # @param [Integer] exit_status
  # @param [Integer] term_signal
  # @return [nil]
  # @scope class
  #
  callback :exit_cb, [Process.by_ref, :long_long, :int], :void

  # (Not documented)
  #
  # @method `callback_walk_cb`(handle, arg)
  # @param [Handle] handle
  # @param [FFI::Pointer(*Void)] arg
  # @return [nil]
  # @scope class
  #
  callback :walk_cb, [Handle.by_ref, :pointer], :void

  # (Not documented)
  #
  # @method `callback_fs_cb`(req)
  # @param [Fs] req
  # @return [nil]
  # @scope class
  #
  callback :fs_cb, [Fs.by_ref], :void

  # (Not documented)
  #
  # @method `callback_work_cb`(req)
  # @param [Work] req
  # @return [nil]
  # @scope class
  #
  callback :work_cb, [Work.by_ref], :void

  # (Not documented)
  #
  # @method `callback_after_work_cb`(req, status)
  # @param [Work] req
  # @param [Integer] status
  # @return [nil]
  # @scope class
  #
  callback :after_work_cb, [Work.by_ref, :int], :void

  # (Not documented)
  #
  # @method `callback_getaddrinfo_cb`(req, status, res)
  # @param [Getaddrinfo] req
  # @param [Integer] status
  # @param [FFI::Pointer(*Addrinfo)] res
  # @return [nil]
  # @scope class
  #
  callback :getaddrinfo_cb, [Getaddrinfo.by_ref, :int, :pointer], :void

  # This will be called repeatedly after the uv_fs_event_t is initialized.
  # If uv_fs_event_t was initialized with a directory the filename parameter
  # will be a relative path to a file contained in the directory.
  # The events parameter is an ORed mask of enum uv_fs_event elements.
  #
  # @method `callback_fs_event_cb`(handle, filename, events, status)
  # @param [FsEvent] handle
  # @param [String] filename
  # @param [Integer] events
  # @param [Integer] status
  # @return [nil]
  # @scope class
  #
  callback :fs_event_cb, [FsEvent.by_ref, :string, :int, :int], :void

  # (Not documented)
  #
  # @method `callback_fs_poll_cb`(handle, status, prev, curr)
  # @param [FsPoll] handle
  # @param [Integer] status
  # @param [Stat] prev
  # @param [Stat] curr
  # @return [nil]
  # @scope class
  #
  callback :fs_poll_cb, [FsPoll.by_ref, :int, Stat.by_ref, Stat.by_ref], :void

  # (Not documented)
  #
  # @method `callback_signal_cb`(handle, signum)
  # @param [Signal] handle
  # @param [Integer] signum
  # @return [nil]
  # @scope class
  #
  callback :signal_cb, [Signal.by_ref, :int], :void

  # Called after uv_udp_send(). status 0 indicates
  # success otherwise error.
  #
  # @method `callback_udp_send_cb`(req, status)
  # @param [UdpSend] req
  # @param [Integer] status
  # @return [nil]
  # @scope class
  #
  callback :udp_send_cb, [UdpSend.by_ref, :int], :void

  # Callback that is invoked when a new UDP datagram is received.
  #
  #  handle  UDP handle.
  #  nread   Number of bytes that have been received.
  #          0 if there is no more data to read. You may
  #          discard or repurpose the read buffer.
  #          < 0 if a transmission error was detected.
  #  buf     uv_buf_t with the received data.
  #  addr    struct sockaddr* containing the address of the sender.
  #          Can be NULL. Valid for the duration of the callback only.
  #  flags   One or more OR'ed UV_UDP_* constants.
  #          Right now only UV_UDP_PARTIAL is used.
  #
  # @method `callback_udp_recv_cb`(handle, nread, buf, addr, flags)
  # @param [Udp] handle
  # @param [Integer] nread
  # @param [Buf] buf
  # @param [FFI::Pointer(*Sockaddr)] addr
  # @param [Integer] flags
  # @return [nil]
  # @scope class
  #
  callback :udp_recv_cb, [Udp.by_ref, :long, Buf.by_ref, :pointer, :uint], :void

  # Returns the libuv version packed into a single integer. 8 bits are used for
  # each component, with the patch number stored in the 8 least significant
  # bits. E.g. for libuv 1.2.3 this would return 0x010203.
  #
  # @method version()
  # @return [Integer]
  # @scope class
  #
  attach_function :version, :uv_version, [], :uint

  # Returns the libuv version number as a string. For non-release versions
  # "-pre" is appended, so the version number could be "1.2.3-pre".
  #
  # @method version_string()
  # @return [String]
  # @scope class
  #
  attach_function :version_string, :uv_version_string, [], :string

  # Returns the default loop.
  #
  # @method default_loop()
  # @return [Loop]
  # @scope class
  #
  attach_function :default_loop, :uv_default_loop, [], Loop.by_ref

  # Initializes a uv_loop_t structure.
  #
  # @method loop_init(loop)
  # @param [Loop] loop
  # @return [Integer]
  # @scope class
  #
  attach_function :loop_init, :uv_loop_init, [Loop.by_ref], :int

  # Closes all internal loop resources.  This function must only be called once
  # the loop has finished it's execution or it will return UV_EBUSY.  After this
  # function returns the user shall free the memory allocated for the loop.
  #
  # @method loop_close(loop)
  # @param [Loop] loop
  # @return [Integer]
  # @scope class
  #
  attach_function :loop_close, :uv_loop_close, [Loop.by_ref], :int

  # Allocates and initializes a new loop.
  # NOTE: This function is DEPRECATED (to be removed after 0.12), users should
  # allocate the loop manually and use uv_loop_init instead.
  #
  # @method loop_new()
  # @return [Loop]
  # @scope class
  #
  attach_function :loop_new, :uv_loop_new, [], Loop.by_ref

  # Cleans up a loop once it has finished executio and frees its memory.
  # NOTE: This function is DEPRECATED (to be removed after 0.12). Users should use
  # uv_loop_close and free the memory manually instead.
  #
  # @method loop_delete(loop)
  # @param [Loop] loop
  # @return [nil]
  # @scope class
  #
  attach_function :loop_delete, :uv_loop_delete, [Loop.by_ref], :void

  # This function runs the event loop. It will act differently depending on the
  # specified mode:
  #  - UV_RUN_DEFAULT: Runs the event loop until the reference count drops to
  #    zero. Always returns zero.
  #  - UV_RUN_ONCE: Poll for new events once. Note that this function blocks if
  #    there are no pending events. Returns zero when done (no active handles
  #    or requests left), or non-zero if more events are expected (meaning you
  #    should run the event loop again sometime in the future).
  #  - UV_RUN_NOWAIT: Poll for new events once but don't block if there are no
  #    pending events.
  #
  # @method run(loop, mode)
  # @param [Loop] loop
  # @param [Symbol from `enum_run_mode`] mode
  # @return [Integer]
  # @scope class
  #
  attach_function :run, :uv_run, [Loop.by_ref, :run_mode], :int

  # This function checks whether the reference count, the number of active
  # handles or requests left in the event loop, is non-zero.
  #
  # @method loop_alive(loop)
  # @param [Loop] loop
  # @return [Integer]
  # @scope class
  #
  attach_function :loop_alive, :uv_loop_alive, [Loop.by_ref], :int

  # This function will stop the event loop by forcing uv_run to end
  # as soon as possible, but not sooner than the next loop iteration.
  # If this function was called before blocking for i/o, the loop won't
  # block for i/o on this iteration.
  #
  # @method stop(loop)
  # @param [Loop] loop
  # @return [nil]
  # @scope class
  #
  attach_function :stop, :uv_stop, [Loop.by_ref], :void

  # Manually modify the event loop's reference count. Useful if the user wants
  # to have a handle or timeout that doesn't keep the loop alive.
  #
  # @method ref(handle)
  # @param [Handle] handle
  # @return [nil]
  # @scope class
  #
  attach_function :ref, :uv_ref, [Handle.by_ref], :void

  # (Not documented)
  #
  # @method unref(handle)
  # @param [Handle] handle
  # @return [nil]
  # @scope class
  #
  attach_function :unref, :uv_unref, [Handle.by_ref], :void

  # (Not documented)
  #
  # @method has_ref(handle)
  # @param [Handle] handle
  # @return [Integer]
  # @scope class
  #
  attach_function :has_ref, :uv_has_ref, [Handle.by_ref], :int

  # Update the event loop's concept of "now". Libuv caches the current time
  # at the start of the event loop tick in order to reduce the number of
  # time-related system calls.
  #
  # You won't normally need to call this function unless you have callbacks
  # that block the event loop for longer periods of time, where "longer" is
  # somewhat subjective but probably on the order of a millisecond or more.
  #
  # @method update_time(loop)
  # @param [Loop] loop
  # @return [nil]
  # @scope class
  #
  attach_function :update_time, :uv_update_time, [Loop.by_ref], :void

  # Return the current timestamp in milliseconds. The timestamp is cached at
  # the start of the event loop tick, see |uv_update_time()| for details and
  # rationale.
  #
  # The timestamp increases monotonically from some arbitrary point in time.
  # Don't make assumptions about the starting point, you will only get
  # disappointed.
  #
  # Use uv_hrtime() if you need sub-millisecond granularity.
  #
  # @method now(loop)
  # @param [Loop] loop
  # @return [Integer]
  # @scope class
  #
  attach_function :now, :uv_now, [Loop.by_ref], :ulong_long

  # Get backend file descriptor. Only kqueue, epoll and event ports are
  # supported.
  #
  # This can be used in conjunction with `uv_run(loop, UV_RUN_NOWAIT)` to
  # poll in one thread and run the event loop's event callbacks in another.
  #
  # Useful for embedding libuv's event loop in another event loop.
  # See test/test-embed.c for an example.
  #
  # Note that embedding a kqueue fd in another kqueue pollset doesn't work on
  # all platforms. It's not an error to add the fd but it never generates
  # events.
  #
  # @method backend_fd(loop)
  # @param [Loop] loop
  # @return [Integer]
  # @scope class
  #
  attach_function :backend_fd, :uv_backend_fd, [Loop.by_ref], :int

  # Get the poll timeout. The return value is in milliseconds, or -1 for no
  # timeout.
  #
  # @method backend_timeout(loop)
  # @param [Loop] loop
  # @return [Integer]
  # @scope class
  #
  attach_function :backend_timeout, :uv_backend_timeout, [Loop.by_ref], :int

  # Most functions return 0 on success or an error code < 0 on failure.
  #
  # @method strerror(err)
  # @param [Integer] err
  # @return [String]
  # @scope class
  #
  attach_function :strerror, :uv_strerror, [:int], :string

  # (Not documented)
  #
  # @method err_name(err)
  # @param [Integer] err
  # @return [String]
  # @scope class
  #
  attach_function :err_name, :uv_err_name, [:int], :string

  # uv_shutdown_t is a subclass of uv_req_t
  #
  # Shutdown the outgoing (write) side of a duplex stream. It waits for
  # pending write requests to complete. The handle should refer to a
  # initialized stream. req should be an uninitialized shutdown request
  # struct. The cb is called after shutdown is complete.
  #
  # @method shutdown(req, handle, cb)
  # @param [Shutdown] req
  # @param [Stream] handle
  # @param [Proc(callback_shutdown_cb)] cb
  # @return [Integer]
  # @scope class
  #
  attach_function :shutdown, :uv_shutdown, [Shutdown.by_ref, Stream.by_ref, :shutdown_cb], :int

  # Returns size of various handle types, useful for FFI
  # bindings to allocate correct memory without copying struct
  # definitions
  #
  # @method handle_size(type)
  # @param [Symbol from `enum_handle_type`] type
  # @return [Integer]
  # @scope class
  #
  attach_function :handle_size, :uv_handle_size, [:handle_type], :ulong

  # Returns size of request types, useful for dynamic lookup with FFI
  #
  # @method req_size(type)
  # @param [Symbol from `enum_req_type`] type
  # @return [Integer]
  # @scope class
  #
  attach_function :req_size, :uv_req_size, [:req_type], :ulong

  # Returns non-zero if the handle is active, zero if it's inactive.
  #
  # What "active" means depends on the type of handle:
  #
  #  - A uv_async_t handle is always active and cannot be deactivated, except
  #    by closing it with uv_close().
  #
  #  - A uv_pipe_t, uv_tcp_t, uv_udp_t, etc. handle - basically any handle that
  #    deals with I/O - is active when it is doing something that involves I/O,
  #    like reading, writing, connecting, accepting new connections, etc.
  #
  #  - A uv_check_t, uv_idle_t, uv_timer_t, etc. handle is active when it has
  #    been started with a call to uv_check_start(), uv_idle_start(), etc.
  #
  #      Rule of thumb: if a handle of type uv_foo_t has a uv_foo_start()
  #      function, then it's active from the moment that function is called.
  #      Likewise, uv_foo_stop() deactivates the handle again.
  #
  # @method is_active(handle)
  # @param [Handle] handle
  # @return [Integer]
  # @scope class
  #
  attach_function :is_active, :uv_is_active, [Handle.by_ref], :int

  # Walk the list of open handles.
  #
  # @method walk(loop, walk_cb, arg)
  # @param [Loop] loop
  # @param [Proc(callback_walk_cb)] walk_cb
  # @param [FFI::Pointer(*Void)] arg
  # @return [nil]
  # @scope class
  #
  attach_function :walk, :uv_walk, [Loop.by_ref, :walk_cb, :pointer], :void

  # Request handle to be closed. close_cb will be called asynchronously after
  # this call. This MUST be called on each handle before memory is released.
  #
  # Note that handles that wrap file descriptors are closed immediately but
  # close_cb will still be deferred to the next iteration of the event loop.
  # It gives you a chance to free up any resources associated with the handle.
  #
  # In-progress requests, like uv_connect_t or uv_write_t, are cancelled and
  # have their callbacks called asynchronously with status=UV_ECANCELED.
  #
  # @method close(handle, close_cb)
  # @param [Handle] handle
  # @param [Proc(callback_close_cb)] close_cb
  # @return [nil]
  # @scope class
  #
  attach_function :close, :uv_close, [Handle.by_ref, :close_cb], :void

  # Constructor for uv_buf_t.
  # Due to platform differences the user cannot rely on the ordering of the
  # base and len members of the uv_buf_t struct. The user is responsible for
  # freeing base after the uv_buf_t is done. Return struct passed by value.
  #
  # @method buf_init(base, len)
  # @param [String] base
  # @param [Integer] len
  # @return [Buf]
  # @scope class
  #
  attach_function :buf_init, :uv_buf_init, [:string, :uint], Buf.by_value

  # (Not documented)
  #
  # @method listen(stream, backlog, cb)
  # @param [Stream] stream
  # @param [Integer] backlog
  # @param [Proc(callback_connection_cb)] cb
  # @return [Integer]
  # @scope class
  #
  attach_function :listen, :uv_listen, [Stream.by_ref, :int, :connection_cb], :int

  # This call is used in conjunction with uv_listen() to accept incoming
  # connections. Call uv_accept after receiving a uv_connection_cb to accept
  # the connection. Before calling uv_accept use uv_*_init() must be
  # called on the client. Non-zero return value indicates an error.
  #
  # When the uv_connection_cb is called it is guaranteed that uv_accept will
  # complete successfully the first time. If you attempt to use it more than
  # once, it may fail. It is suggested to only call uv_accept once per
  # uv_connection_cb call.
  #
  # @method accept(server, client)
  # @param [Stream] server
  # @param [Stream] client
  # @return [Integer]
  # @scope class
  #
  attach_function :accept, :uv_accept, [Stream.by_ref, Stream.by_ref], :int

  # Read data from an incoming stream. The callback will be made several
  # times until there is no more data to read or uv_read_stop is called.
  # When we've reached EOF nread will be set to UV_EOF.
  #
  # When nread < 0, the buf parameter might not point to a valid buffer;
  # in that case buf.len and buf.base are both set to 0.
  #
  # Note that nread might also be 0, which does *not* indicate an error or
  # eof; it happens when libuv requested a buffer through the alloc callback
  # but then decided that it didn't need that buffer.
  #
  # @method read_start(stream, alloc_cb, read_cb)
  # @param [Stream] stream
  # @param [Proc(callback_alloc_cb)] alloc_cb
  # @param [Proc(callback_read_cb)] read_cb
  # @return [Integer]
  # @scope class
  #
  attach_function :read_start, :uv_read_start, [Stream.by_ref, :alloc_cb, :read_cb], :int

  # (Not documented)
  #
  # @method read_stop(stream)
  # @param [Stream] stream
  # @return [Integer]
  # @scope class
  #
  attach_function :read_stop, :uv_read_stop, [Stream.by_ref], :int

  # Write data to stream. Buffers are written in order. Example:
  #
  #   uv_buf_t a() = {
  #     { .base = "1", .len = 1 },
  #     { .base = "2", .len = 1 }
  #   };
  #
  #   uv_buf_t b() = {
  #     { .base = "3", .len = 1 },
  #     { .base = "4", .len = 1 }
  #   };
  #
  #   uv_write_t req1;
  #   uv_write_t req2;
  #
  #   // writes "1234"
  #   uv_write(&req1, stream, a, 2);
  #   uv_write(&req2, stream, b, 2);
  #
  # @method write(req, handle, bufs, nbufs, cb)
  # @param [Write] req
  # @param [Stream] handle
  # @param [Array<unknown>] bufs
  # @param [Integer] nbufs
  # @param [Proc(callback_write_cb)] cb
  # @return [Integer]
  # @scope class
  #
  attach_function :write, :uv_write, [Write.by_ref, Stream.by_ref, :pointer, :uint, :write_cb], :int

  # Extended write function for sending handles over a pipe. The pipe must be
  # initialized with ipc == 1.
  # send_handle must be a TCP socket or pipe, which is a server or a connection
  # (listening or connected state).  Bound sockets or pipes will be assumed to
  # be servers.
  #
  # @method write2(req, handle, bufs, nbufs, send_handle, cb)
  # @param [Write] req
  # @param [Stream] handle
  # @param [Array<unknown>] bufs
  # @param [Integer] nbufs
  # @param [Stream] send_handle
  # @param [Proc(callback_write_cb)] cb
  # @return [Integer]
  # @scope class
  #
  attach_function :write2, :uv_write2, [Write.by_ref, Stream.by_ref, :pointer, :uint, Stream.by_ref, :write_cb], :int

  # Same as `uv_write()`, but won't queue write request if it can't be completed
  # immediately.
  # Will return either:
  # - >= 0: number of bytes written (can be less than the supplied buffer size)
  # - < 0: negative error code
  #
  # @method try_write(handle, bufs, nbufs)
  # @param [Stream] handle
  # @param [Array<unknown>] bufs
  # @param [Integer] nbufs
  # @return [Integer]
  # @scope class
  #
  attach_function :try_write, :uv_try_write, [Stream.by_ref, :pointer, :uint], :int

  # Used to determine whether a stream is readable or writable.
  #
  # @method is_readable(handle)
  # @param [Stream] handle
  # @return [Integer]
  # @scope class
  #
  attach_function :is_readable, :uv_is_readable, [Stream.by_ref], :int

  # (Not documented)
  #
  # @method is_writable(handle)
  # @param [Stream] handle
  # @return [Integer]
  # @scope class
  #
  attach_function :is_writable, :uv_is_writable, [Stream.by_ref], :int

  # Enable or disable blocking mode for a stream.
  #
  # When blocking mode is enabled all writes complete synchronously. The
  # interface remains unchanged otherwise, e.g. completion or failure of the
  # operation will still be reported through a callback which is made
  # asychronously.
  #
  # Relying too much on this API is not recommended. It is likely to change
  # significantly in the future.
  #
  # Currently this only works on Windows and only for uv_pipe_t handles.
  #
  # Also libuv currently makes no ordering guarantee when the blocking mode
  # is changed after write requests have already been submitted. Therefore it is
  # recommended to set the blocking mode immediately after opening or creating
  # the stream.
  #
  # @method stream_set_blocking(handle, blocking)
  # @param [Stream] handle
  # @param [Integer] blocking
  # @return [Integer]
  # @scope class
  #
  attach_function :stream_set_blocking, :uv_stream_set_blocking, [Stream.by_ref, :int], :int

  # Used to determine whether a stream is closing or closed.
  #
  # N.B. is only valid between the initialization of the handle
  #      and the arrival of the close callback, and cannot be used
  #      to validate the handle.
  #
  # @method is_closing(handle)
  # @param [Handle] handle
  # @return [Integer]
  # @scope class
  #
  attach_function :is_closing, :uv_is_closing, [Handle.by_ref], :int

  # (Not documented)
  #
  # @method tcp_init(loop, handle)
  # @param [Loop] loop
  # @param [Tcp] handle
  # @return [Integer]
  # @scope class
  #
  attach_function :tcp_init, :uv_tcp_init, [Loop.by_ref, Tcp.by_ref], :int

  # Opens an existing file descriptor or SOCKET as a tcp handle.
  #
  # @method tcp_open(handle, sock)
  # @param [Tcp] handle
  # @param [Integer] sock
  # @return [Integer]
  # @scope class
  #
  attach_function :tcp_open, :uv_tcp_open, [Tcp.by_ref, :int], :int

  # Enable/disable Nagle's algorithm.
  #
  # @method tcp_nodelay(handle, enable)
  # @param [Tcp] handle
  # @param [Integer] enable
  # @return [Integer]
  # @scope class
  #
  attach_function :tcp_nodelay, :uv_tcp_nodelay, [Tcp.by_ref, :int], :int

  # Enable/disable TCP keep-alive.
  #
  # `delay` is the initial delay in seconds, ignored when `enable` is zero.
  #
  # @method tcp_keepalive(handle, enable, delay)
  # @param [Tcp] handle
  # @param [Integer] enable
  # @param [Integer] delay
  # @return [Integer]
  # @scope class
  #
  attach_function :tcp_keepalive, :uv_tcp_keepalive, [Tcp.by_ref, :int, :uint], :int

  # Enable/disable simultaneous asynchronous accept requests that are
  # queued by the operating system when listening for new tcp connections.
  # This setting is used to tune a tcp server for the desired performance.
  # Having simultaneous accepts can significantly improve the rate of
  # accepting connections (which is why it is enabled by default) but
  # may lead to uneven load distribution in multi-process setups.
  #
  # @method tcp_simultaneous_accepts(handle, enable)
  # @param [Tcp] handle
  # @param [Integer] enable
  # @return [Integer]
  # @scope class
  #
  attach_function :tcp_simultaneous_accepts, :uv_tcp_simultaneous_accepts, [Tcp.by_ref, :int], :int

  # Bind the handle to an address and port.  `addr` should point to an
  # initialized struct sockaddr_in or struct sockaddr_in6.
  #
  # When the port is already taken, you can expect to see an UV_EADDRINUSE
  # error from either uv_tcp_bind(), uv_listen() or uv_tcp_connect().
  #
  # That is, a successful call to uv_tcp_bind() does not guarantee that
  # the call to uv_listen() or uv_tcp_connect() will succeed as well.
  #
  # @method tcp_bind(handle, addr, flags)
  # @param [Tcp] handle
  # @param [FFI::Pointer(*Sockaddr)] addr
  # @param [Integer] flags
  # @return [Integer]
  # @scope class
  #
  attach_function :tcp_bind, :uv_tcp_bind, [Tcp.by_ref, :pointer, :uint], :int

  # (Not documented)
  #
  # @method tcp_getsockname(handle, name, namelen)
  # @param [Tcp] handle
  # @param [FFI::Pointer(*Sockaddr)] name
  # @param [FFI::Pointer(*Int)] namelen
  # @return [Integer]
  # @scope class
  #
  attach_function :tcp_getsockname, :uv_tcp_getsockname, [Tcp.by_ref, :pointer, :pointer], :int

  # (Not documented)
  #
  # @method tcp_getpeername(handle, name, namelen)
  # @param [Tcp] handle
  # @param [FFI::Pointer(*Sockaddr)] name
  # @param [FFI::Pointer(*Int)] namelen
  # @return [Integer]
  # @scope class
  #
  attach_function :tcp_getpeername, :uv_tcp_getpeername, [Tcp.by_ref, :pointer, :pointer], :int

  # Establish an IPv4 or IPv6 TCP connection.  Provide an initialized TCP handle
  # and an uninitialized uv_connect_t*.  `addr` should point to an initialized
  # struct sockaddr_in or struct sockaddr_in6.
  #
  # The callback is made when the connection has been established or when a
  # connection error happened.
  #
  # @method tcp_connect(req, handle, addr, cb)
  # @param [Connect] req
  # @param [Tcp] handle
  # @param [FFI::Pointer(*Sockaddr)] addr
  # @param [Proc(callback_connect_cb)] cb
  # @return [Integer]
  # @scope class
  #
  attach_function :tcp_connect, :uv_tcp_connect, [Connect.by_ref, Tcp.by_ref, :pointer, :connect_cb], :int

  # Initialize a new UDP handle. The actual socket is created lazily.
  # Returns 0 on success.
  #
  # @method udp_init(loop, handle)
  # @param [Loop] loop
  # @param [Udp] handle
  # @return [Integer]
  # @scope class
  #
  attach_function :udp_init, :uv_udp_init, [Loop.by_ref, Udp.by_ref], :int

  # Opens an existing file descriptor or SOCKET as a udp handle.
  #
  # Unix only:
  #  The only requirement of the sock argument is that it follows the
  #  datagram contract (works in unconnected mode, supports sendmsg()/recvmsg(),
  #  etc.). In other words, other datagram-type sockets like raw sockets or
  #  netlink sockets can also be passed to this function.
  #
  # This sets the SO_REUSEPORT socket flag on the BSDs and OS X. On other
  # UNIX platforms, it sets the SO_REUSEADDR flag.  What that means is that
  # multiple threads or processes can bind to the same address without error
  # (provided they all set the flag) but only the last one to bind will receive
  # any traffic, in effect "stealing" the port from the previous listener.
  # This behavior is something of an anomaly and may be replaced by an explicit
  # opt-in mechanism in future versions of libuv.
  #
  # @method udp_open(handle, sock)
  # @param [Udp] handle
  # @param [Integer] sock
  # @return [Integer]
  # @scope class
  #
  attach_function :udp_open, :uv_udp_open, [Udp.by_ref, :int], :int

  # Bind to an IP address and port.
  #
  # Arguments:
  #  handle    UDP handle. Should have been initialized with `uv_udp_init`.
  #  addr      struct sockaddr_in or struct sockaddr_in6 with the address and
  #            port to bind to.
  #  flags     Indicate how the socket will be bound, UV_UDP_IPV6ONLY and
  #            UV_UDP_REUSEADDR are supported.
  #
  # Returns:
  #  0 on success, or an error code < 0 on failure.
  #
  # @method udp_bind(handle, addr, flags)
  # @param [Udp] handle
  # @param [FFI::Pointer(*Sockaddr)] addr
  # @param [Integer] flags
  # @return [Integer]
  # @scope class
  #
  attach_function :udp_bind, :uv_udp_bind, [Udp.by_ref, :pointer, :uint], :int

  # (Not documented)
  #
  # @method udp_getsockname(handle, name, namelen)
  # @param [Udp] handle
  # @param [FFI::Pointer(*Sockaddr)] name
  # @param [FFI::Pointer(*Int)] namelen
  # @return [Integer]
  # @scope class
  #
  attach_function :udp_getsockname, :uv_udp_getsockname, [Udp.by_ref, :pointer, :pointer], :int

  # Set membership for a multicast address
  #
  # Arguments:
  #  handle              UDP handle. Should have been initialized with
  #                      `uv_udp_init`.
  #  multicast_addr      multicast address to set membership for
  #  interface_addr      interface address
  #  membership          Should be UV_JOIN_GROUP or UV_LEAVE_GROUP
  #
  # Returns:
  #  0 on success, or an error code < 0 on failure.
  #
  # @method udp_set_membership(handle, multicast_addr, interface_addr, membership)
  # @param [Udp] handle
  # @param [String] multicast_addr
  # @param [String] interface_addr
  # @param [Symbol from `enum_membership`] membership
  # @return [Integer]
  # @scope class
  #
  attach_function :udp_set_membership, :uv_udp_set_membership, [Udp.by_ref, :string, :string, :membership], :int

  # Set IP multicast loop flag. Makes multicast packets loop back to
  # local sockets.
  #
  # Arguments:
  #  handle              UDP handle. Should have been initialized with
  #                      `uv_udp_init`.
  #  on                  1 for on, 0 for off
  #
  # Returns:
  #  0 on success, or an error code < 0 on failure.
  #
  # @method udp_set_multicast_loop(handle, on)
  # @param [Udp] handle
  # @param [Integer] on
  # @return [Integer]
  # @scope class
  #
  attach_function :udp_set_multicast_loop, :uv_udp_set_multicast_loop, [Udp.by_ref, :int], :int

  # Set the multicast ttl
  #
  # Arguments:
  #  handle              UDP handle. Should have been initialized with
  #                      `uv_udp_init`.
  #  ttl                 1 through 255
  #
  # Returns:
  #  0 on success, or an error code < 0 on failure.
  #
  # @method udp_set_multicast_ttl(handle, ttl)
  # @param [Udp] handle
  # @param [Integer] ttl
  # @return [Integer]
  # @scope class
  #
  attach_function :udp_set_multicast_ttl, :uv_udp_set_multicast_ttl, [Udp.by_ref, :int], :int

  # Set the multicast interface to send on
  #
  # Arguments:
  #  handle              UDP handle. Should have been initialized with
  #                      `uv_udp_init`.
  #  interface_addr      interface address
  #
  # Returns:
  #  0 on success, or an error code < 0 on failure.
  #
  # @method udp_set_multicast_interface(handle, interface_addr)
  # @param [Udp] handle
  # @param [String] interface_addr
  # @return [Integer]
  # @scope class
  #
  attach_function :udp_set_multicast_interface, :uv_udp_set_multicast_interface, [Udp.by_ref, :string], :int

  # Set broadcast on or off
  #
  # Arguments:
  #  handle              UDP handle. Should have been initialized with
  #                      `uv_udp_init`.
  #  on                  1 for on, 0 for off
  #
  # Returns:
  #  0 on success, or an error code < 0 on failure.
  #
  # @method udp_set_broadcast(handle, on)
  # @param [Udp] handle
  # @param [Integer] on
  # @return [Integer]
  # @scope class
  #
  attach_function :udp_set_broadcast, :uv_udp_set_broadcast, [Udp.by_ref, :int], :int

  # Set the time to live
  #
  # Arguments:
  #  handle              UDP handle. Should have been initialized with
  #                      `uv_udp_init`.
  #  ttl                 1 through 255
  #
  # Returns:
  #  0 on success, or an error code < 0 on failure.
  #
  # @method udp_set_ttl(handle, ttl)
  # @param [Udp] handle
  # @param [Integer] ttl
  # @return [Integer]
  # @scope class
  #
  attach_function :udp_set_ttl, :uv_udp_set_ttl, [Udp.by_ref, :int], :int

  # Send data. If the socket has not previously been bound with `uv_udp_bind,`
  # it is bound to 0.0.0.0 (the "all interfaces" address) and a random
  # port number.
  #
  # Arguments:
  #  req       UDP request handle. Need not be initialized.
  #  handle    UDP handle. Should have been initialized with `uv_udp_init`.
  #  bufs      List of buffers to send.
  #  nbufs     Number of buffers in `bufs`.
  #  addr      struct sockaddr_in or struct sockaddr_in6 with the address and
  #            port of the remote peer.
  #  send_cb   Callback to invoke when the data has been sent out.
  #
  # Returns:
  #  0 on success, or an error code < 0 on failure.
  #
  # @method udp_send(req, handle, bufs, nbufs, addr, send_cb)
  # @param [UdpSend] req
  # @param [Udp] handle
  # @param [Array<unknown>] bufs
  # @param [Integer] nbufs
  # @param [FFI::Pointer(*Sockaddr)] addr
  # @param [Proc(callback_udp_send_cb)] send_cb
  # @return [Integer]
  # @scope class
  #
  attach_function :udp_send, :uv_udp_send, [UdpSend.by_ref, Udp.by_ref, :pointer, :uint, :pointer, :udp_send_cb], :int

  # Receive data. If the socket has not previously been bound with `uv_udp_bind`
  # it is bound to 0.0.0.0 (the "all interfaces" address) and a random
  # port number.
  #
  # Arguments:
  #  handle    UDP handle. Should have been initialized with `uv_udp_init`.
  #  alloc_cb  Callback to invoke when temporary storage is needed.
  #  recv_cb   Callback to invoke with received data.
  #
  # Returns:
  #  0 on success, or an error code < 0 on failure.
  #
  # @method udp_recv_start(handle, alloc_cb, recv_cb)
  # @param [Udp] handle
  # @param [Proc(callback_alloc_cb)] alloc_cb
  # @param [Proc(callback_udp_recv_cb)] recv_cb
  # @return [Integer]
  # @scope class
  #
  attach_function :udp_recv_start, :uv_udp_recv_start, [Udp.by_ref, :alloc_cb, :udp_recv_cb], :int

  # Stop listening for incoming datagrams.
  #
  # Arguments:
  #  handle    UDP handle. Should have been initialized with `uv_udp_init`.
  #
  # Returns:
  #  0 on success, or an error code < 0 on failure.
  #
  # @method udp_recv_stop(handle)
  # @param [Udp] handle
  # @return [Integer]
  # @scope class
  #
  attach_function :udp_recv_stop, :uv_udp_recv_stop, [Udp.by_ref], :int

  # Initialize a new TTY stream with the given file descriptor. Usually the
  # file descriptor will be
  #   0 = stdin
  #   1 = stdout
  #   2 = stderr
  # The last argument, readable, specifies if you plan on calling
  # uv_read_start with this stream. stdin is readable, stdout is not.
  #
  # TTY streams which are not readable have blocking writes.
  #
  # @method tty_init(loop, tty, fd, readable)
  # @param [Loop] loop
  # @param [Tty] tty
  # @param [Integer] fd
  # @param [Integer] readable
  # @return [Integer]
  # @scope class
  #
  attach_function :tty_init, :uv_tty_init, [Loop.by_ref, Tty.by_ref, :int, :int], :int

  # Set mode. 0 for normal, 1 for raw.
  #
  # @method tty_set_mode(tty, mode)
  # @param [Tty] tty
  # @param [Integer] mode
  # @return [Integer]
  # @scope class
  #
  attach_function :tty_set_mode, :uv_tty_set_mode, [Tty.by_ref, :int], :int

  # To be called when the program exits. Resets TTY settings to default
  # values for the next process to take over.
  #
  # This function is async signal-safe on UNIX platforms but can fail with error
  # code UV_EBUSY if you call it when execution is inside uv_tty_set_mode().
  #
  # @method tty_reset_mode()
  # @return [Integer]
  # @scope class
  #
  attach_function :tty_reset_mode, :uv_tty_reset_mode, [], :int

  # Gets the current Window size. On success zero is returned.
  #
  # @method tty_get_winsize(tty, width, height)
  # @param [Tty] tty
  # @param [FFI::Pointer(*Int)] width
  # @param [FFI::Pointer(*Int)] height
  # @return [Integer]
  # @scope class
  #
  attach_function :tty_get_winsize, :uv_tty_get_winsize, [Tty.by_ref, :pointer, :pointer], :int

  # Used to detect what type of stream should be used with a given file
  # descriptor. Usually this will be used during initialization to guess the
  # type of the stdio streams.
  # For isatty() functionality use this function and test for UV_TTY.
  #
  # @method guess_handle(file)
  # @param [Integer] file
  # @return [Symbol from `enum_handle_type`]
  # @scope class
  #
  attach_function :guess_handle, :uv_guess_handle, [:int], :handle_type

  # Initialize a pipe. The last argument is a boolean to indicate if
  # this pipe will be used for handle passing between processes.
  #
  # @method pipe_init(loop, handle, ipc)
  # @param [Loop] loop
  # @param [Pipe] handle
  # @param [Integer] ipc
  # @return [Integer]
  # @scope class
  #
  attach_function :pipe_init, :uv_pipe_init, [Loop.by_ref, Pipe.by_ref, :int], :int

  # Opens an existing file descriptor or HANDLE as a pipe.
  #
  # @method pipe_open(pipe, file)
  # @param [Pipe] pipe
  # @param [Integer] file
  # @return [Integer]
  # @scope class
  #
  attach_function :pipe_open, :uv_pipe_open, [Pipe.by_ref, :int], :int

  # Bind the pipe to a file path (UNIX) or a name (Windows.)
  #
  # Paths on UNIX get truncated to `sizeof(sockaddr_un.sun_path)` bytes,
  # typically between 92 and 108 bytes.
  #
  # @method pipe_bind(handle, name)
  # @param [Pipe] handle
  # @param [String] name
  # @return [Integer]
  # @scope class
  #
  attach_function :pipe_bind, :uv_pipe_bind, [Pipe.by_ref, :string], :int

  # Connect to the UNIX domain socket or the named pipe.
  #
  # Paths on UNIX get truncated to `sizeof(sockaddr_un.sun_path)` bytes,
  # typically between 92 and 108 bytes.
  #
  # @method pipe_connect(req, handle, name, cb)
  # @param [Connect] req
  # @param [Pipe] handle
  # @param [String] name
  # @param [Proc(callback_connect_cb)] cb
  # @return [nil]
  # @scope class
  #
  attach_function :pipe_connect, :uv_pipe_connect, [Connect.by_ref, Pipe.by_ref, :string, :connect_cb], :void

  # Get the name of the UNIX domain socket or the named pipe.
  #
  # A preallocated buffer must be provided. The len parameter holds the
  # length of the buffer and it's set to the number of bytes written to the
  # buffer on output. If the buffer is not big enough UV_ENOBUFS will be
  # returned and len will contain the required size.
  #
  # @method pipe_getsockname(handle, buf, len)
  # @param [Pipe] handle
  # @param [String] buf
  # @param [FFI::Pointer(*Size)] len
  # @return [Integer]
  # @scope class
  #
  attach_function :pipe_getsockname, :uv_pipe_getsockname, [Pipe.by_ref, :string, :pointer], :int

  # This setting applies to Windows only.
  # Set the number of pending pipe instance handles when the pipe server
  # is waiting for connections.
  #
  # @method pipe_pending_instances(handle, count)
  # @param [Pipe] handle
  # @param [Integer] count
  # @return [nil]
  # @scope class
  #
  attach_function :pipe_pending_instances, :uv_pipe_pending_instances, [Pipe.by_ref, :int], :void

  # Used to receive handles over ipc pipes.
  #
  # First - call `uv_pipe_pending_count`, if it is > 0 - initialize handle
  # using type, returned by `uv_pipe_pending_type` and call
  # `uv_accept(pipe, handle)`.
  #
  # @method pipe_pending_count(handle)
  # @param [Pipe] handle
  # @return [Integer]
  # @scope class
  #
  attach_function :pipe_pending_count, :uv_pipe_pending_count, [Pipe.by_ref], :int

  # (Not documented)
  #
  # @method pipe_pending_type(handle)
  # @param [Pipe] handle
  # @return [Symbol from `enum_handle_type`]
  # @scope class
  #
  attach_function :pipe_pending_type, :uv_pipe_pending_type, [Pipe.by_ref], :handle_type

  # Initialize the poll watcher using a file descriptor.
  #
  # @method poll_init(loop, handle, fd)
  # @param [Loop] loop
  # @param [Poll] handle
  # @param [Integer] fd
  # @return [Integer]
  # @scope class
  #
  attach_function :poll_init, :uv_poll_init, [Loop.by_ref, Poll.by_ref, :int], :int

  # identical to uv_poll_init. On windows it takes a SOCKET handle.
  #
  # @method poll_init_socket(loop, handle, socket)
  # @param [Loop] loop
  # @param [Poll] handle
  # @param [Integer] socket
  # @return [Integer]
  # @scope class
  #
  attach_function :poll_init_socket, :uv_poll_init_socket, [Loop.by_ref, Poll.by_ref, :int], :int

  # Starts polling the file descriptor. `events` is a bitmask consisting made up
  # of UV_READABLE and UV_WRITABLE. As soon as an event is detected the callback
  # will be called with `status` set to 0, and the detected events set en the
  # `events` field.
  #
  # If an error happens while polling status, `status` < 0 and corresponds
  # with one of the UV_E* error codes. The user should not close the socket
  # while uv_poll is active. If the user does that anyway, the callback *may*
  # be called reporting an error status, but this is not guaranteed.
  #
  # Calling uv_poll_start on an uv_poll watcher that is already active is fine.
  # Doing so will update the events mask that is being watched for.
  #
  # @method poll_start(handle, events, cb)
  # @param [Poll] handle
  # @param [Integer] events
  # @param [Proc(callback_poll_cb)] cb
  # @return [Integer]
  # @scope class
  #
  attach_function :poll_start, :uv_poll_start, [Poll.by_ref, :int, :poll_cb], :int

  # Stops polling the file descriptor.
  #
  # @method poll_stop(handle)
  # @param [Poll] handle
  # @return [Integer]
  # @scope class
  #
  attach_function :poll_stop, :uv_poll_stop, [Poll.by_ref], :int

  # (Not documented)
  #
  # @method prepare_init(loop, prepare)
  # @param [Loop] loop
  # @param [Prepare] prepare
  # @return [Integer]
  # @scope class
  #
  attach_function :prepare_init, :uv_prepare_init, [Loop.by_ref, Prepare.by_ref], :int

  # (Not documented)
  #
  # @method prepare_start(prepare, cb)
  # @param [Prepare] prepare
  # @param [Proc(callback_prepare_cb)] cb
  # @return [Integer]
  # @scope class
  #
  attach_function :prepare_start, :uv_prepare_start, [Prepare.by_ref, :prepare_cb], :int

  # (Not documented)
  #
  # @method prepare_stop(prepare)
  # @param [Prepare] prepare
  # @return [Integer]
  # @scope class
  #
  attach_function :prepare_stop, :uv_prepare_stop, [Prepare.by_ref], :int

  # (Not documented)
  #
  # @method check_init(loop, check)
  # @param [Loop] loop
  # @param [Check] check
  # @return [Integer]
  # @scope class
  #
  attach_function :check_init, :uv_check_init, [Loop.by_ref, Check.by_ref], :int

  # (Not documented)
  #
  # @method check_start(check, cb)
  # @param [Check] check
  # @param [Proc(callback_check_cb)] cb
  # @return [Integer]
  # @scope class
  #
  attach_function :check_start, :uv_check_start, [Check.by_ref, :check_cb], :int

  # (Not documented)
  #
  # @method check_stop(check)
  # @param [Check] check
  # @return [Integer]
  # @scope class
  #
  attach_function :check_stop, :uv_check_stop, [Check.by_ref], :int

  # (Not documented)
  #
  # @method idle_init(loop, idle)
  # @param [Loop] loop
  # @param [Idle] idle
  # @return [Integer]
  # @scope class
  #
  attach_function :idle_init, :uv_idle_init, [Loop.by_ref, Idle.by_ref], :int

  # (Not documented)
  #
  # @method idle_start(idle, cb)
  # @param [Idle] idle
  # @param [Proc(callback_idle_cb)] cb
  # @return [Integer]
  # @scope class
  #
  attach_function :idle_start, :uv_idle_start, [Idle.by_ref, :idle_cb], :int

  # (Not documented)
  #
  # @method idle_stop(idle)
  # @param [Idle] idle
  # @return [Integer]
  # @scope class
  #
  attach_function :idle_stop, :uv_idle_stop, [Idle.by_ref], :int

  # Initialize the uv_async_t handle. A NULL callback is allowed.
  #
  # Note that uv_async_init(), unlike other libuv functions, immediately
  # starts the handle. To stop the handle again, close it with uv_close().
  #
  # @method async_init(loop, async, async_cb)
  # @param [Loop] loop
  # @param [Async] async
  # @param [Proc(callback_async_cb)] async_cb
  # @return [Integer]
  # @scope class
  #
  attach_function :async_init, :uv_async_init, [Loop.by_ref, Async.by_ref, :async_cb], :int

  # This can be called from other threads to wake up a libuv thread.
  #
  # @method async_send(async)
  # @param [Async] async
  # @return [Integer]
  # @scope class
  #
  attach_function :async_send, :uv_async_send, [Async.by_ref], :int

  # (Not documented)
  #
  # @method timer_init(loop, handle)
  # @param [Loop] loop
  # @param [Timer] handle
  # @return [Integer]
  # @scope class
  #
  attach_function :timer_init, :uv_timer_init, [Loop.by_ref, Timer.by_ref], :int

  # Start the timer. `timeout` and `repeat` are in milliseconds.
  #
  # If timeout is zero, the callback fires on the next tick of the event loop.
  #
  # If repeat is non-zero, the callback fires first after timeout milliseconds
  # and then repeatedly after repeat milliseconds.
  #
  # @method timer_start(handle, cb, timeout, repeat)
  # @param [Timer] handle
  # @param [Proc(callback_timer_cb)] cb
  # @param [Integer] timeout
  # @param [Integer] repeat
  # @return [Integer]
  # @scope class
  #
  attach_function :timer_start, :uv_timer_start, [Timer.by_ref, :timer_cb, :ulong_long, :ulong_long], :int

  # (Not documented)
  #
  # @method timer_stop(handle)
  # @param [Timer] handle
  # @return [Integer]
  # @scope class
  #
  attach_function :timer_stop, :uv_timer_stop, [Timer.by_ref], :int

  # Stop the timer, and if it is repeating restart it using the repeat value
  # as the timeout. If the timer has never been started before it returns
  # UV_EINVAL.
  #
  # @method timer_again(handle)
  # @param [Timer] handle
  # @return [Integer]
  # @scope class
  #
  attach_function :timer_again, :uv_timer_again, [Timer.by_ref], :int

  # Set the repeat value in milliseconds. Note that if the repeat value is set
  # from a timer callback it does not immediately take effect. If the timer was
  # non-repeating before, it will have been stopped. If it was repeating, then
  # the old repeat value will have been used to schedule the next timeout.
  #
  # @method timer_set_repeat(handle, repeat)
  # @param [Timer] handle
  # @param [Integer] repeat
  # @return [nil]
  # @scope class
  #
  attach_function :timer_set_repeat, :uv_timer_set_repeat, [Timer.by_ref, :ulong_long], :void

  # (Not documented)
  #
  # @method timer_get_repeat(handle)
  # @param [Timer] handle
  # @return [Integer]
  # @scope class
  #
  attach_function :timer_get_repeat, :uv_timer_get_repeat, [Timer.by_ref], :ulong_long

  # Asynchronous getaddrinfo(3).
  #
  # Either node or service may be NULL but not both.
  #
  # hints is a pointer to a struct addrinfo with additional address type
  # constraints, or NULL. Consult `man -s 3 getaddrinfo` for details.
  #
  # Returns 0 on success or an error code < 0 on failure.
  #
  # If successful, your callback gets called sometime in the future with the
  # lookup result, which is either:
  #
  #  a) err == 0, the res argument points to a valid struct addrinfo, or
  #  b) err < 0, the res argument is NULL. See the UV_EAI_* constants.
  #
  # Call uv_freeaddrinfo() to free the addrinfo structure.
  #
  # @method getaddrinfo(loop, req, getaddrinfo_cb, node, service, hints)
  # @param [Loop] loop
  # @param [Getaddrinfo] req
  # @param [Proc(callback_getaddrinfo_cb)] getaddrinfo_cb
  # @param [String] node
  # @param [String] service
  # @param [FFI::Pointer(*Addrinfo)] hints
  # @return [Integer]
  # @scope class
  #
  attach_function :getaddrinfo, :uv_getaddrinfo, [Loop.by_ref, Getaddrinfo.by_ref, :getaddrinfo_cb, :string, :string, :pointer], :int

  # Free the struct addrinfo. Passing NULL is allowed and is a no-op.
  #
  # @method freeaddrinfo(ai)
  # @param [FFI::Pointer(*Addrinfo)] ai
  # @return [nil]
  # @scope class
  #
  attach_function :freeaddrinfo, :uv_freeaddrinfo, [:pointer], :void

  # Initializes the uv_process_t and starts the process. If the process is
  # successfully spawned, then this function will return 0. Otherwise, the
  # negative error code corresponding to the reason it couldn't spawn is
  # returned.
  #
  # Possible reasons for failing to spawn would include (but not be limited to)
  # the file to execute not existing, not having permissions to use the setuid or
  # setgid specified, or not having enough memory to allocate for the new
  # process.
  #
  # @method spawn(loop, handle, options)
  # @param [Loop] loop
  # @param [Process] handle
  # @param [ProcessOptions] options
  # @return [Integer]
  # @scope class
  #
  attach_function :spawn, :uv_spawn, [Loop.by_ref, Process.by_ref, ProcessOptions.by_ref], :int

  # Kills the process with the specified signal. The user must still
  # call uv_close on the process.
  #
  # Emulates some aspects of Unix exit status on Windows, in that while the
  # underlying process will be terminated with a status of `1`,
  # `uv_process_t.exit_signal` will be set to signum, so the process will appear
  # to have been killed by `signum`.
  #
  # @method process_kill(process, signum)
  # @param [Process] process
  # @param [Integer] signum
  # @return [Integer]
  # @scope class
  #
  attach_function :process_kill, :uv_process_kill, [Process.by_ref, :int], :int

  # Kills the process with the specified signal.
  #
  # Emulates some aspects of Unix signals on Windows:
  # - SIGTERM, SIGKILL, and SIGINT call TerminateProcess() to unconditionally
  #   cause the target to exit with status 1. Unlike Unix, this cannot be caught
  #   or ignored (but see uv_process_kill() and uv_signal_start()).
  # - Signal number `0` causes a check for target existence, as in Unix. Return
  #   value is 0 on existence, UV_ESRCH on non-existence.
  #
  # Returns 0 on success, or an error code on failure. UV_ESRCH is portably used
  # for non-existence of target process, other errors may be system specific.
  #
  # @method kill(pid, signum)
  # @param [Integer] pid
  # @param [Integer] signum
  # @return [Integer]
  # @scope class
  #
  attach_function :kill, :uv_kill, [:int, :int], :int

  # Queues a work request to execute asynchronously on the thread pool.
  #
  # @method queue_work(loop, req, work_cb, after_work_cb)
  # @param [Loop] loop
  # @param [Work] req
  # @param [Proc(callback_work_cb)] work_cb
  # @param [Proc(callback_after_work_cb)] after_work_cb
  # @return [Integer]
  # @scope class
  #
  attach_function :queue_work, :uv_queue_work, [Loop.by_ref, Work.by_ref, :work_cb, :after_work_cb], :int

  # Cancel a pending request. Fails if the request is executing or has finished
  # executing.
  #
  # Returns 0 on success, or an error code < 0 on failure.
  #
  # Only cancellation of uv_fs_t, uv_getaddrinfo_t and uv_work_t requests is
  # currently supported.
  #
  # Cancelled requests have their callbacks invoked some time in the future.
  # It's _not_ safe to free the memory associated with the request until your
  # callback is called.
  #
  # Here is how cancellation is reported to your callback:
  #
  # - A uv_fs_t request has its req->result field set to UV_ECANCELED.
  #
  # - A uv_work_t or uv_getaddrinfo_t request has its callback invoked with
  #   status == UV_ECANCELED.
  #
  # This function is currently only implemented on UNIX platforms. On Windows,
  # it always returns UV_ENOSYS.
  #
  # @method cancel(req)
  # @param [Req] req
  # @return [Integer]
  # @scope class
  #
  attach_function :cancel, :uv_cancel, [Req.by_ref], :int

  # (Not documented)
  #
  # @method setup_args(argc, argv)
  # @param [Integer] argc
  # @param [FFI::Pointer(**CharS)] argv
  # @return [FFI::Pointer(**CharS)]
  # @scope class
  #
  attach_function :setup_args, :uv_setup_args, [:int, :pointer], :pointer

  # (Not documented)
  #
  # @method get_process_title(buffer, size)
  # @param [String] buffer
  # @param [Integer] size
  # @return [Integer]
  # @scope class
  #
  attach_function :get_process_title, :uv_get_process_title, [:string, :ulong], :int

  # (Not documented)
  #
  # @method set_process_title(title)
  # @param [String] title
  # @return [Integer]
  # @scope class
  #
  attach_function :set_process_title, :uv_set_process_title, [:string], :int

  # (Not documented)
  #
  # @method resident_set_memory(rss)
  # @param [FFI::Pointer(*Size)] rss
  # @return [Integer]
  # @scope class
  #
  attach_function :resident_set_memory, :uv_resident_set_memory, [:pointer], :int

  # (Not documented)
  #
  # @method uptime(uptime)
  # @param [FFI::Pointer(*Double)] uptime
  # @return [Integer]
  # @scope class
  #
  attach_function :uptime, :uv_uptime, [:pointer], :int

  # Get information about OS resource utilization for the current process.
  # Please note that not all uv_rusage_t struct fields will be filled on Windows.
  #
  # @method getrusage(rusage)
  # @param [Rusage] rusage
  # @return [Integer]
  # @scope class
  #
  attach_function :getrusage, :uv_getrusage, [Rusage.by_ref], :int

  # This allocates cpu_infos array, and sets count.  The array
  # is freed using uv_free_cpu_info().
  #
  # @method cpu_info(cpu_infos, count)
  # @param [FFI::Pointer(**CpuInfo)] cpu_infos
  # @param [FFI::Pointer(*Int)] count
  # @return [Integer]
  # @scope class
  #
  attach_function :cpu_info, :uv_cpu_info, [:pointer, :pointer], :int

  # (Not documented)
  #
  # @method free_cpu_info(cpu_infos, count)
  # @param [CpuInfo] cpu_infos
  # @param [Integer] count
  # @return [nil]
  # @scope class
  #
  attach_function :free_cpu_info, :uv_free_cpu_info, [CpuInfo.by_ref, :int], :void

  # This allocates addresses array, and sets count.  The array
  # is freed using uv_free_interface_addresses().
  #
  # @method interface_addresses(addresses, count)
  # @param [FFI::Pointer(**InterfaceAddress)] addresses
  # @param [FFI::Pointer(*Int)] count
  # @return [Integer]
  # @scope class
  #
  attach_function :interface_addresses, :uv_interface_addresses, [:pointer, :pointer], :int

  # (Not documented)
  #
  # @method free_interface_addresses(addresses, count)
  # @param [InterfaceAddress] addresses
  # @param [Integer] count
  # @return [nil]
  # @scope class
  #
  attach_function :free_interface_addresses, :uv_free_interface_addresses, [InterfaceAddress.by_ref, :int], :void

  # (Not documented)
  #
  # @method fs_req_cleanup(req)
  # @param [Fs] req
  # @return [nil]
  # @scope class
  #
  attach_function :fs_req_cleanup, :uv_fs_req_cleanup, [Fs.by_ref], :void

  # (Not documented)
  #
  # @method fs_close(loop, req, file, cb)
  # @param [Loop] loop
  # @param [Fs] req
  # @param [Integer] file
  # @param [Proc(callback_fs_cb)] cb
  # @return [Integer]
  # @scope class
  #
  attach_function :fs_close, :uv_fs_close, [Loop.by_ref, Fs.by_ref, :int, :fs_cb], :int

  # (Not documented)
  #
  # @method fs_open(loop, req, path, flags, mode, cb)
  # @param [Loop] loop
  # @param [Fs] req
  # @param [String] path
  # @param [Integer] flags
  # @param [Integer] mode
  # @param [Proc(callback_fs_cb)] cb
  # @return [Integer]
  # @scope class
  #
  attach_function :fs_open, :uv_fs_open, [Loop.by_ref, Fs.by_ref, :string, :int, :int, :fs_cb], :int

  # (Not documented)
  #
  # @method fs_read(loop, req, file, bufs, nbufs, offset, cb)
  # @param [Loop] loop
  # @param [Fs] req
  # @param [Integer] file
  # @param [Array<unknown>] bufs
  # @param [Integer] nbufs
  # @param [Integer] offset
  # @param [Proc(callback_fs_cb)] cb
  # @return [Integer]
  # @scope class
  #
  attach_function :fs_read, :uv_fs_read, [Loop.by_ref, Fs.by_ref, :int, :pointer, :uint, :long_long, :fs_cb], :int

  # (Not documented)
  #
  # @method fs_unlink(loop, req, path, cb)
  # @param [Loop] loop
  # @param [Fs] req
  # @param [String] path
  # @param [Proc(callback_fs_cb)] cb
  # @return [Integer]
  # @scope class
  #
  attach_function :fs_unlink, :uv_fs_unlink, [Loop.by_ref, Fs.by_ref, :string, :fs_cb], :int

  # (Not documented)
  #
  # @method fs_write(loop, req, file, bufs, nbufs, offset, cb)
  # @param [Loop] loop
  # @param [Fs] req
  # @param [Integer] file
  # @param [Array<unknown>] bufs
  # @param [Integer] nbufs
  # @param [Integer] offset
  # @param [Proc(callback_fs_cb)] cb
  # @return [Integer]
  # @scope class
  #
  attach_function :fs_write, :uv_fs_write, [Loop.by_ref, Fs.by_ref, :int, :pointer, :uint, :long_long, :fs_cb], :int

  # (Not documented)
  #
  # @method fs_mkdir(loop, req, path, mode, cb)
  # @param [Loop] loop
  # @param [Fs] req
  # @param [String] path
  # @param [Integer] mode
  # @param [Proc(callback_fs_cb)] cb
  # @return [Integer]
  # @scope class
  #
  attach_function :fs_mkdir, :uv_fs_mkdir, [Loop.by_ref, Fs.by_ref, :string, :int, :fs_cb], :int

  # (Not documented)
  #
  # @method fs_rmdir(loop, req, path, cb)
  # @param [Loop] loop
  # @param [Fs] req
  # @param [String] path
  # @param [Proc(callback_fs_cb)] cb
  # @return [Integer]
  # @scope class
  #
  attach_function :fs_rmdir, :uv_fs_rmdir, [Loop.by_ref, Fs.by_ref, :string, :fs_cb], :int

  # (Not documented)
  #
  # @method fs_readdir(loop, req, path, flags, cb)
  # @param [Loop] loop
  # @param [Fs] req
  # @param [String] path
  # @param [Integer] flags
  # @param [Proc(callback_fs_cb)] cb
  # @return [Integer]
  # @scope class
  #
  attach_function :fs_readdir, :uv_fs_readdir, [Loop.by_ref, Fs.by_ref, :string, :int, :fs_cb], :int

  # (Not documented)
  #
  # @method fs_stat(loop, req, path, cb)
  # @param [Loop] loop
  # @param [Fs] req
  # @param [String] path
  # @param [Proc(callback_fs_cb)] cb
  # @return [Integer]
  # @scope class
  #
  attach_function :fs_stat, :uv_fs_stat, [Loop.by_ref, Fs.by_ref, :string, :fs_cb], :int

  # (Not documented)
  #
  # @method fs_fstat(loop, req, file, cb)
  # @param [Loop] loop
  # @param [Fs] req
  # @param [Integer] file
  # @param [Proc(callback_fs_cb)] cb
  # @return [Integer]
  # @scope class
  #
  attach_function :fs_fstat, :uv_fs_fstat, [Loop.by_ref, Fs.by_ref, :int, :fs_cb], :int

  # (Not documented)
  #
  # @method fs_rename(loop, req, path, new_path, cb)
  # @param [Loop] loop
  # @param [Fs] req
  # @param [String] path
  # @param [String] new_path
  # @param [Proc(callback_fs_cb)] cb
  # @return [Integer]
  # @scope class
  #
  attach_function :fs_rename, :uv_fs_rename, [Loop.by_ref, Fs.by_ref, :string, :string, :fs_cb], :int

  # (Not documented)
  #
  # @method fs_fsync(loop, req, file, cb)
  # @param [Loop] loop
  # @param [Fs] req
  # @param [Integer] file
  # @param [Proc(callback_fs_cb)] cb
  # @return [Integer]
  # @scope class
  #
  attach_function :fs_fsync, :uv_fs_fsync, [Loop.by_ref, Fs.by_ref, :int, :fs_cb], :int

  # (Not documented)
  #
  # @method fs_fdatasync(loop, req, file, cb)
  # @param [Loop] loop
  # @param [Fs] req
  # @param [Integer] file
  # @param [Proc(callback_fs_cb)] cb
  # @return [Integer]
  # @scope class
  #
  attach_function :fs_fdatasync, :uv_fs_fdatasync, [Loop.by_ref, Fs.by_ref, :int, :fs_cb], :int

  # (Not documented)
  #
  # @method fs_ftruncate(loop, req, file, offset, cb)
  # @param [Loop] loop
  # @param [Fs] req
  # @param [Integer] file
  # @param [Integer] offset
  # @param [Proc(callback_fs_cb)] cb
  # @return [Integer]
  # @scope class
  #
  attach_function :fs_ftruncate, :uv_fs_ftruncate, [Loop.by_ref, Fs.by_ref, :int, :long_long, :fs_cb], :int

  # (Not documented)
  #
  # @method fs_sendfile(loop, req, out_fd, in_fd, in_offset, length, cb)
  # @param [Loop] loop
  # @param [Fs] req
  # @param [Integer] out_fd
  # @param [Integer] in_fd
  # @param [Integer] in_offset
  # @param [Integer] length
  # @param [Proc(callback_fs_cb)] cb
  # @return [Integer]
  # @scope class
  #
  attach_function :fs_sendfile, :uv_fs_sendfile, [Loop.by_ref, Fs.by_ref, :int, :int, :long_long, :ulong, :fs_cb], :int

  # (Not documented)
  #
  # @method fs_chmod(loop, req, path, mode, cb)
  # @param [Loop] loop
  # @param [Fs] req
  # @param [String] path
  # @param [Integer] mode
  # @param [Proc(callback_fs_cb)] cb
  # @return [Integer]
  # @scope class
  #
  attach_function :fs_chmod, :uv_fs_chmod, [Loop.by_ref, Fs.by_ref, :string, :int, :fs_cb], :int

  # (Not documented)
  #
  # @method fs_utime(loop, req, path, atime, mtime, cb)
  # @param [Loop] loop
  # @param [Fs] req
  # @param [String] path
  # @param [Float] atime
  # @param [Float] mtime
  # @param [Proc(callback_fs_cb)] cb
  # @return [Integer]
  # @scope class
  #
  attach_function :fs_utime, :uv_fs_utime, [Loop.by_ref, Fs.by_ref, :string, :double, :double, :fs_cb], :int

  # (Not documented)
  #
  # @method fs_futime(loop, req, file, atime, mtime, cb)
  # @param [Loop] loop
  # @param [Fs] req
  # @param [Integer] file
  # @param [Float] atime
  # @param [Float] mtime
  # @param [Proc(callback_fs_cb)] cb
  # @return [Integer]
  # @scope class
  #
  attach_function :fs_futime, :uv_fs_futime, [Loop.by_ref, Fs.by_ref, :int, :double, :double, :fs_cb], :int

  # (Not documented)
  #
  # @method fs_lstat(loop, req, path, cb)
  # @param [Loop] loop
  # @param [Fs] req
  # @param [String] path
  # @param [Proc(callback_fs_cb)] cb
  # @return [Integer]
  # @scope class
  #
  attach_function :fs_lstat, :uv_fs_lstat, [Loop.by_ref, Fs.by_ref, :string, :fs_cb], :int

  # (Not documented)
  #
  # @method fs_link(loop, req, path, new_path, cb)
  # @param [Loop] loop
  # @param [Fs] req
  # @param [String] path
  # @param [String] new_path
  # @param [Proc(callback_fs_cb)] cb
  # @return [Integer]
  # @scope class
  #
  attach_function :fs_link, :uv_fs_link, [Loop.by_ref, Fs.by_ref, :string, :string, :fs_cb], :int

  # This flag can be used with uv_fs_symlink on Windows
  # to specify whether the symlink is to be created using junction points.
  #
  # @method fs_symlink(loop, req, path, new_path, flags, cb)
  # @param [Loop] loop
  # @param [Fs] req
  # @param [String] path
  # @param [String] new_path
  # @param [Integer] flags
  # @param [Proc(callback_fs_cb)] cb
  # @return [Integer]
  # @scope class
  #
  attach_function :fs_symlink, :uv_fs_symlink, [Loop.by_ref, Fs.by_ref, :string, :string, :int, :fs_cb], :int

  # (Not documented)
  #
  # @method fs_readlink(loop, req, path, cb)
  # @param [Loop] loop
  # @param [Fs] req
  # @param [String] path
  # @param [Proc(callback_fs_cb)] cb
  # @return [Integer]
  # @scope class
  #
  attach_function :fs_readlink, :uv_fs_readlink, [Loop.by_ref, Fs.by_ref, :string, :fs_cb], :int

  # (Not documented)
  #
  # @method fs_fchmod(loop, req, file, mode, cb)
  # @param [Loop] loop
  # @param [Fs] req
  # @param [Integer] file
  # @param [Integer] mode
  # @param [Proc(callback_fs_cb)] cb
  # @return [Integer]
  # @scope class
  #
  attach_function :fs_fchmod, :uv_fs_fchmod, [Loop.by_ref, Fs.by_ref, :int, :int, :fs_cb], :int

  # (Not documented)
  #
  # @method fs_chown(loop, req, path, uid, gid, cb)
  # @param [Loop] loop
  # @param [Fs] req
  # @param [String] path
  # @param [Integer] uid
  # @param [Integer] gid
  # @param [Proc(callback_fs_cb)] cb
  # @return [Integer]
  # @scope class
  #
  attach_function :fs_chown, :uv_fs_chown, [Loop.by_ref, Fs.by_ref, :string, :uint, :uint, :fs_cb], :int

  # (Not documented)
  #
  # @method fs_fchown(loop, req, file, uid, gid, cb)
  # @param [Loop] loop
  # @param [Fs] req
  # @param [Integer] file
  # @param [Integer] uid
  # @param [Integer] gid
  # @param [Proc(callback_fs_cb)] cb
  # @return [Integer]
  # @scope class
  #
  attach_function :fs_fchown, :uv_fs_fchown, [Loop.by_ref, Fs.by_ref, :int, :uint, :uint, :fs_cb], :int

  # (Not documented)
  #
  # @method fs_poll_init(loop, handle)
  # @param [Loop] loop
  # @param [FsPoll] handle
  # @return [Integer]
  # @scope class
  #
  attach_function :fs_poll_init, :uv_fs_poll_init, [Loop.by_ref, FsPoll.by_ref], :int

  # Check the file at `path` for changes every `interval` milliseconds.
  #
  # Your callback is invoked with `status < 0` if `path` does not exist
  # or is inaccessible. The watcher is *not* stopped but your callback is
  # not called again until something changes (e.g. when the file is created
  # or the error reason changes).
  #
  # When `status == 0`, your callback receives pointers to the old and new
  # `uv_stat_t` structs. They are valid for the duration of the callback
  # only!
  #
  # For maximum portability, use multi-second intervals. Sub-second intervals
  # will not detect all changes on many file systems.
  #
  # @method fs_poll_start(handle, poll_cb, path, interval)
  # @param [FsPoll] handle
  # @param [Proc(callback_fs_poll_cb)] poll_cb
  # @param [String] path
  # @param [Integer] interval
  # @return [Integer]
  # @scope class
  #
  attach_function :fs_poll_start, :uv_fs_poll_start, [FsPoll.by_ref, :fs_poll_cb, :string, :uint], :int

  # (Not documented)
  #
  # @method fs_poll_stop(handle)
  # @param [FsPoll] handle
  # @return [Integer]
  # @scope class
  #
  attach_function :fs_poll_stop, :uv_fs_poll_stop, [FsPoll.by_ref], :int

  # Get the path being monitored by the handle. The buffer must be preallocated
  # by the user. Returns 0 on success or an error code < 0 in case of failure.
  # On sucess, `buf` will contain the path and `len` its length. If the buffer
  # is not big enough UV_ENOBUFS will be returned and len will be set to the
  # required size.
  #
  # @method fs_poll_getpath(handle, buf, len)
  # @param [FsPoll] handle
  # @param [String] buf
  # @param [FFI::Pointer(*Size)] len
  # @return [Integer]
  # @scope class
  #
  attach_function :fs_poll_getpath, :uv_fs_poll_getpath, [FsPoll.by_ref, :string, :pointer], :int

  # (Not documented)
  #
  # @method signal_init(loop, handle)
  # @param [Loop] loop
  # @param [Signal] handle
  # @return [Integer]
  # @scope class
  #
  attach_function :signal_init, :uv_signal_init, [Loop.by_ref, Signal.by_ref], :int

  # (Not documented)
  #
  # @method signal_start(handle, signal_cb, signum)
  # @param [Signal] handle
  # @param [Proc(callback_signal_cb)] signal_cb
  # @param [Integer] signum
  # @return [Integer]
  # @scope class
  #
  attach_function :signal_start, :uv_signal_start, [Signal.by_ref, :signal_cb, :int], :int

  # (Not documented)
  #
  # @method signal_stop(handle)
  # @param [Signal] handle
  # @return [Integer]
  # @scope class
  #
  attach_function :signal_stop, :uv_signal_stop, [Signal.by_ref], :int

  # Gets load average.
  # See: http://en.wikipedia.org/wiki/Load_(computing)
  # Returns (0,0,0) on Windows.
  #
  # @method loadavg(avg)
  # @param [Array<Float>, 3] avg
  # @return [nil]
  # @scope class
  #
  attach_function :loadavg, :uv_loadavg, [:pointer], :void

  # (Not documented)
  #
  # @method fs_event_init(loop, handle)
  # @param [Loop] loop
  # @param [FsEvent] handle
  # @return [Integer]
  # @scope class
  #
  attach_function :fs_event_init, :uv_fs_event_init, [Loop.by_ref, FsEvent.by_ref], :int

  # (Not documented)
  #
  # @method fs_event_start(handle, cb, path, flags)
  # @param [FsEvent] handle
  # @param [Proc(callback_fs_event_cb)] cb
  # @param [String] path
  # @param [Integer] flags
  # @return [Integer]
  # @scope class
  #
  attach_function :fs_event_start, :uv_fs_event_start, [FsEvent.by_ref, :fs_event_cb, :string, :uint], :int

  # (Not documented)
  #
  # @method fs_event_stop(handle)
  # @param [FsEvent] handle
  # @return [Integer]
  # @scope class
  #
  attach_function :fs_event_stop, :uv_fs_event_stop, [FsEvent.by_ref], :int

  # Get the path being monitored by the handle. The buffer must be preallocated
  # by the user. Returns 0 on success or an error code < 0 in case of failure.
  # On sucess, `buf` will contain the path and `len` its length. If the buffer
  # is not big enough UV_ENOBUFS will be returned and len will be set to the
  # required size.
  #
  # @method fs_event_getpath(handle, buf, len)
  # @param [FsEvent] handle
  # @param [String] buf
  # @param [FFI::Pointer(*Size)] len
  # @return [Integer]
  # @scope class
  #
  attach_function :fs_event_getpath, :uv_fs_event_getpath, [FsEvent.by_ref, :string, :pointer], :int

  # Convert string ip addresses to binary structures
  #
  # @method ip4_addr(ip, port, addr)
  # @param [String] ip
  # @param [Integer] port
  # @param [FFI::Pointer(*SockaddrIn)] addr
  # @return [Integer]
  # @scope class
  #
  attach_function :ip4_addr, :uv_ip4_addr, [:string, :int, :pointer], :int

  # (Not documented)
  #
  # @method ip6_addr(ip, port, addr)
  # @param [String] ip
  # @param [Integer] port
  # @param [FFI::Pointer(*SockaddrIn6)] addr
  # @return [Integer]
  # @scope class
  #
  attach_function :ip6_addr, :uv_ip6_addr, [:string, :int, :pointer], :int

  # Convert binary addresses to strings
  #
  # @method ip4_name(src, dst, size)
  # @param [FFI::Pointer(*SockaddrIn)] src
  # @param [String] dst
  # @param [Integer] size
  # @return [Integer]
  # @scope class
  #
  attach_function :ip4_name, :uv_ip4_name, [:pointer, :string, :ulong], :int

  # (Not documented)
  #
  # @method ip6_name(src, dst, size)
  # @param [FFI::Pointer(*SockaddrIn6)] src
  # @param [String] dst
  # @param [Integer] size
  # @return [Integer]
  # @scope class
  #
  attach_function :ip6_name, :uv_ip6_name, [:pointer, :string, :ulong], :int

  # the target of the `dst` pointer is unmodified.
  #
  # @method inet_ntop(af, src, dst, size)
  # @param [Integer] af
  # @param [FFI::Pointer(*Void)] src
  # @param [String] dst
  # @param [Integer] size
  # @return [Integer]
  # @scope class
  #
  attach_function :inet_ntop, :uv_inet_ntop, [:int, :pointer, :string, :ulong], :int

  # (Not documented)
  #
  # @method inet_pton(af, src, dst)
  # @param [Integer] af
  # @param [String] src
  # @param [FFI::Pointer(*Void)] dst
  # @return [Integer]
  # @scope class
  #
  attach_function :inet_pton, :uv_inet_pton, [:int, :string, :pointer], :int

  # Gets the executable path
  #
  # @method exepath(buffer, size)
  # @param [String] buffer
  # @param [FFI::Pointer(*Size)] size
  # @return [Integer]
  # @scope class
  #
  attach_function :exepath, :uv_exepath, [:string, :pointer], :int

  # Gets the current working directory
  #
  # @method cwd(buffer, size)
  # @param [String] buffer
  # @param [FFI::Pointer(*Size)] size
  # @return [Integer]
  # @scope class
  #
  attach_function :cwd, :uv_cwd, [:string, :pointer], :int

  # Changes the current working directory
  #
  # @method chdir(dir)
  # @param [String] dir
  # @return [Integer]
  # @scope class
  #
  attach_function :chdir, :uv_chdir, [:string], :int

  # Gets memory info in bytes
  #
  # @method get_free_memory()
  # @return [Integer]
  # @scope class
  #
  attach_function :get_free_memory, :uv_get_free_memory, [], :ulong_long

  # (Not documented)
  #
  # @method get_total_memory()
  # @return [Integer]
  # @scope class
  #
  attach_function :get_total_memory, :uv_get_total_memory, [], :ulong_long

  # Returns the current high-resolution real time. This is expressed in
  # nanoseconds. It is relative to an arbitrary time in the past. It is not
  # related to the time of day and therefore not subject to clock drift. The
  # primary use is for measuring performance between intervals.
  #
  # Note not every platform can support nanosecond resolution; however, this
  # value will always be in nanoseconds.
  #
  # @method hrtime()
  # @return [Integer]
  # @scope class
  #
  attach_function :hrtime, :uv_hrtime, [], :ulong_long

  # Disables inheritance for file descriptors / handles that this process
  # inherited from its parent. The effect is that child processes spawned by
  # this process don't accidentally inherit these handles.
  #
  # It is recommended to call this function as early in your program as possible,
  # before the inherited file descriptors can be closed or duplicated.
  #
  # Note that this function works on a best-effort basis: there is no guarantee
  # that libuv can discover all file descriptors that were inherited. In general
  # it does a better job on Windows than it does on unix.
  #
  # @method disable_stdio_inheritance()
  # @return [nil]
  # @scope class
  #
  attach_function :disable_stdio_inheritance, :uv_disable_stdio_inheritance, [], :void

  # Opens a shared library. The filename is in utf-8. Returns 0 on success and
  # -1 on error. Call `uv_dlerror(uv_lib_t*)` to get the error message.
  #
  # @method dlopen(filename, lib)
  # @param [String] filename
  # @param [Lib] lib
  # @return [Integer]
  # @scope class
  #
  attach_function :dlopen, :uv_dlopen, [:string, Lib.by_ref], :int

  # Close the shared library.
  #
  # @method dlclose(lib)
  # @param [Lib] lib
  # @return [nil]
  # @scope class
  #
  attach_function :dlclose, :uv_dlclose, [Lib.by_ref], :void

  # Retrieves a data pointer from a dynamic library. It is legal for a symbol to
  # map to NULL. Returns 0 on success and -1 if the symbol was not found.
  #
  # @method dlsym(lib, name, ptr)
  # @param [Lib] lib
  # @param [String] name
  # @param [FFI::Pointer(**Void)] ptr
  # @return [Integer]
  # @scope class
  #
  attach_function :dlsym, :uv_dlsym, [Lib.by_ref, :string, :pointer], :int

  # Returns the last uv_dlopen() or uv_dlsym() error message.
  #
  # @method dlerror(lib)
  # @param [Lib] lib
  # @return [String]
  # @scope class
  #
  attach_function :dlerror, :uv_dlerror, [Lib.by_ref], :string

  # The mutex functions return 0 on success or an error code < 0
  # (unless the return type is void, of course).
  #
  # @method mutex_init(handle)
  # @param [FFI::Pointer(*Mutex)] handle
  # @return [Integer]
  # @scope class
  #
  attach_function :mutex_init, :uv_mutex_init, [:pointer], :int

  # (Not documented)
  #
  # @method mutex_destroy(handle)
  # @param [FFI::Pointer(*Mutex)] handle
  # @return [nil]
  # @scope class
  #
  attach_function :mutex_destroy, :uv_mutex_destroy, [:pointer], :void

  # (Not documented)
  #
  # @method mutex_lock(handle)
  # @param [FFI::Pointer(*Mutex)] handle
  # @return [nil]
  # @scope class
  #
  attach_function :mutex_lock, :uv_mutex_lock, [:pointer], :void

  # (Not documented)
  #
  # @method mutex_trylock(handle)
  # @param [FFI::Pointer(*Mutex)] handle
  # @return [Integer]
  # @scope class
  #
  attach_function :mutex_trylock, :uv_mutex_trylock, [:pointer], :int

  # (Not documented)
  #
  # @method mutex_unlock(handle)
  # @param [FFI::Pointer(*Mutex)] handle
  # @return [nil]
  # @scope class
  #
  attach_function :mutex_unlock, :uv_mutex_unlock, [:pointer], :void

  # Same goes for the read/write lock functions.
  #
  # @method rwlock_init(rwlock)
  # @param [FFI::Pointer(*Rwlock)] rwlock
  # @return [Integer]
  # @scope class
  #
  attach_function :rwlock_init, :uv_rwlock_init, [:pointer], :int

  # (Not documented)
  #
  # @method rwlock_destroy(rwlock)
  # @param [FFI::Pointer(*Rwlock)] rwlock
  # @return [nil]
  # @scope class
  #
  attach_function :rwlock_destroy, :uv_rwlock_destroy, [:pointer], :void

  # (Not documented)
  #
  # @method rwlock_rdlock(rwlock)
  # @param [FFI::Pointer(*Rwlock)] rwlock
  # @return [nil]
  # @scope class
  #
  attach_function :rwlock_rdlock, :uv_rwlock_rdlock, [:pointer], :void

  # (Not documented)
  #
  # @method rwlock_tryrdlock(rwlock)
  # @param [FFI::Pointer(*Rwlock)] rwlock
  # @return [Integer]
  # @scope class
  #
  attach_function :rwlock_tryrdlock, :uv_rwlock_tryrdlock, [:pointer], :int

  # (Not documented)
  #
  # @method rwlock_rdunlock(rwlock)
  # @param [FFI::Pointer(*Rwlock)] rwlock
  # @return [nil]
  # @scope class
  #
  attach_function :rwlock_rdunlock, :uv_rwlock_rdunlock, [:pointer], :void

  # (Not documented)
  #
  # @method rwlock_wrlock(rwlock)
  # @param [FFI::Pointer(*Rwlock)] rwlock
  # @return [nil]
  # @scope class
  #
  attach_function :rwlock_wrlock, :uv_rwlock_wrlock, [:pointer], :void

  # (Not documented)
  #
  # @method rwlock_trywrlock(rwlock)
  # @param [FFI::Pointer(*Rwlock)] rwlock
  # @return [Integer]
  # @scope class
  #
  attach_function :rwlock_trywrlock, :uv_rwlock_trywrlock, [:pointer], :int

  # (Not documented)
  #
  # @method rwlock_wrunlock(rwlock)
  # @param [FFI::Pointer(*Rwlock)] rwlock
  # @return [nil]
  # @scope class
  #
  attach_function :rwlock_wrunlock, :uv_rwlock_wrunlock, [:pointer], :void

  # Same goes for the semaphore functions.
  #
  # @method sem_init(sem, value)
  # @param [FFI::Pointer(*Sem)] sem
  # @param [Integer] value
  # @return [Integer]
  # @scope class
  #
  attach_function :sem_init, :uv_sem_init, [:pointer, :uint], :int

  # (Not documented)
  #
  # @method sem_destroy(sem)
  # @param [FFI::Pointer(*Sem)] sem
  # @return [nil]
  # @scope class
  #
  attach_function :sem_destroy, :uv_sem_destroy, [:pointer], :void

  # (Not documented)
  #
  # @method sem_post(sem)
  # @param [FFI::Pointer(*Sem)] sem
  # @return [nil]
  # @scope class
  #
  attach_function :sem_post, :uv_sem_post, [:pointer], :void

  # (Not documented)
  #
  # @method sem_wait(sem)
  # @param [FFI::Pointer(*Sem)] sem
  # @return [nil]
  # @scope class
  #
  attach_function :sem_wait, :uv_sem_wait, [:pointer], :void

  # (Not documented)
  #
  # @method sem_trywait(sem)
  # @param [FFI::Pointer(*Sem)] sem
  # @return [Integer]
  # @scope class
  #
  attach_function :sem_trywait, :uv_sem_trywait, [:pointer], :int

  # Same goes for the condition variable functions.
  #
  # @method cond_init(cond)
  # @param [FFI::Pointer(*Cond)] cond
  # @return [Integer]
  # @scope class
  #
  attach_function :cond_init, :uv_cond_init, [:pointer], :int

  # (Not documented)
  #
  # @method cond_destroy(cond)
  # @param [FFI::Pointer(*Cond)] cond
  # @return [nil]
  # @scope class
  #
  attach_function :cond_destroy, :uv_cond_destroy, [:pointer], :void

  # (Not documented)
  #
  # @method cond_signal(cond)
  # @param [FFI::Pointer(*Cond)] cond
  # @return [nil]
  # @scope class
  #
  attach_function :cond_signal, :uv_cond_signal, [:pointer], :void

  # (Not documented)
  #
  # @method cond_broadcast(cond)
  # @param [FFI::Pointer(*Cond)] cond
  # @return [nil]
  # @scope class
  #
  attach_function :cond_broadcast, :uv_cond_broadcast, [:pointer], :void

  # Waits on a condition variable without a timeout.
  #
  # Note:
  # 1. callers should be prepared to deal with spurious wakeups.
  #
  # @method cond_wait(cond, mutex)
  # @param [FFI::Pointer(*Cond)] cond
  # @param [FFI::Pointer(*Mutex)] mutex
  # @return [nil]
  # @scope class
  #
  attach_function :cond_wait, :uv_cond_wait, [:pointer, :pointer], :void

  # Waits on a condition variable with a timeout in nano seconds.
  # Returns 0 for success or UV_ETIMEDOUT on timeout, It aborts when other
  # errors happen.
  #
  # Note:
  # 1. callers should be prepared to deal with spurious wakeups.
  # 2. the granularity of timeout on Windows is never less than one millisecond.
  # 3. uv_cond_timedwait takes a relative timeout, not an absolute time.
  #
  # @method cond_timedwait(cond, mutex, timeout)
  # @param [FFI::Pointer(*Cond)] cond
  # @param [FFI::Pointer(*Mutex)] mutex
  # @param [Integer] timeout
  # @return [Integer]
  # @scope class
  #
  attach_function :cond_timedwait, :uv_cond_timedwait, [:pointer, :pointer, :ulong_long], :int

  # (Not documented)
  #
  # @method barrier_init(barrier, count)
  # @param [Barrier] barrier
  # @param [Integer] count
  # @return [Integer]
  # @scope class
  #
  attach_function :barrier_init, :uv_barrier_init, [Barrier.by_ref, :uint], :int

  # (Not documented)
  #
  # @method barrier_destroy(barrier)
  # @param [Barrier] barrier
  # @return [nil]
  # @scope class
  #
  attach_function :barrier_destroy, :uv_barrier_destroy, [Barrier.by_ref], :void

  # (Not documented)
  #
  # @method barrier_wait(barrier)
  # @param [Barrier] barrier
  # @return [nil]
  # @scope class
  #
  attach_function :barrier_wait, :uv_barrier_wait, [Barrier.by_ref], :void

  # Runs a function once and only once. Concurrent calls to uv_once() with the
  # same guard will block all callers except one (it's unspecified which one).
  # The guard should be initialized statically with the UV_ONCE_INIT macro.
  #
  # @method once(guard, callback)
  # @param [FFI::Pointer(*Once)] guard
  # @param [FFI::Pointer(*)] callback
  # @return [nil]
  # @scope class
  #
  attach_function :once, :uv_once, [:pointer, :pointer], :void

  # Thread-local storage.  These functions largely follow the semantics of
  # pthread_key_create(), pthread_key_delete(), pthread_getspecific() and
  # pthread_setspecific().
  #
  # Note that the total thread-local storage size may be limited.
  # That is, it may not be possible to create many TLS keys.
  #
  # @method key_create(key)
  # @param [FFI::Pointer(*Key)] key
  # @return [Integer]
  # @scope class
  #
  attach_function :key_create, :uv_key_create, [:pointer], :int

  # (Not documented)
  #
  # @method key_delete(key)
  # @param [FFI::Pointer(*Key)] key
  # @return [nil]
  # @scope class
  #
  attach_function :key_delete, :uv_key_delete, [:pointer], :void

  # (Not documented)
  #
  # @method key_get(key)
  # @param [FFI::Pointer(*Key)] key
  # @return [FFI::Pointer(*Void)]
  # @scope class
  #
  attach_function :key_get, :uv_key_get, [:pointer], :pointer

  # (Not documented)
  #
  # @method key_set(key, value)
  # @param [FFI::Pointer(*Key)] key
  # @param [FFI::Pointer(*Void)] value
  # @return [nil]
  # @scope class
  #
  attach_function :key_set, :uv_key_set, [:pointer, :pointer], :void

  # (Not documented)
  #
  # @method thread_create(tid, entry, arg)
  # @param [FFI::Pointer(*Thread)] tid
  # @param [FFI::Pointer(*)] entry
  # @param [FFI::Pointer(*Void)] arg
  # @return [Integer]
  # @scope class
  #
  attach_function :thread_create, :uv_thread_create, [:pointer, :pointer, :pointer], :int

  # (Not documented)
  #
  # @method thread_self()
  # @return [Integer]
  # @scope class
  #
  attach_function :thread_self, :uv_thread_self, [], :ulong

  # (Not documented)
  #
  # @method thread_join(tid)
  # @param [FFI::Pointer(*Thread)] tid
  # @return [Integer]
  # @scope class
  #
  attach_function :thread_join, :uv_thread_join, [:pointer], :int

end
