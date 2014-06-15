module UV
  # uv_poll_t is a subclass of uv_handle_t.
  #
  # The uv_poll watcher is used to watch file descriptors for readability and
  # writability, similar to the purpose of poll(2).
  #
  # The purpose of uv_poll is to enable integrating external libraries that
  # rely on the event loop to signal it about the socket status changes, like
  # c-ares or libssh2. Using uv_poll_t for any other other purpose is not
  # recommended; uv_tcp_t, uv_udp_t, etc. provide an implementation that is
  # much faster and more scalable than what can be achieved with uv_poll_t,
  # especially on Windows.
  #
  # It is possible that uv_poll occasionally signals that a file descriptor is
  # readable or writable even when it isn't. The user should therefore always
  # be prepared to handle EAGAIN or equivalent when it attempts to read from or
  # write to the fd.
  #
  # It is not okay to have multiple active uv_poll watchers for the same socket.
  # This can cause libuv to busyloop or otherwise malfunction.
  #
  # The user should not close a file descriptor while it is being polled by an
  # active uv_poll watcher. This can cause the poll watcher to report an error,
  # but it might also start polling another socket. However the fd can be safely
  # closed immediately after a call to uv_poll_stop() or uv_close().
  #
  # On windows only sockets can be polled with uv_poll. On unix any file
  # descriptor that would be accepted by poll(2) can be used with uv_poll.
  #
  # ## Fields:
  # :data ::
  #   (FFI::Pointer(*Void))
  # :loop ::
  #   (Loop)
  # :type ::
  #   (Symbol from `enum_handle_type`)
  # :close_cb ::
  #   (Proc(callback_close_cb))
  # :handle_queue ::
  #   (Array<FFI::Pointer(*Void)>)
  # :next_closing ::
  #   (Handle)
  # :flags ::
  #   (Integer)
  # :poll_cb ::
  #   (Proc(callback_poll_cb))
  # :io_watcher ::
  #   (Io)
  module PollWrappers
    # @param [Integer] events
    # @param [Proc(callback_poll_cb)] cb
    # @return [Integer]
    def start(events, cb)
      UV.poll_start(self, events, cb)
    end

    # @return [Integer]
    def stop()
      UV.poll_stop(self)
    end
  end

  class Poll < FFI::Struct
    include PollWrappers
    layout :data, :pointer,
           :loop, Loop.by_ref,
           :type, :handle_type,
           :close_cb, :close_cb,
           :handle_queue, [:pointer, 2],
           :next_closing, Handle.by_ref,
           :flags, :uint,
           :poll_cb, :poll_cb,
           :io_watcher, Io.by_value
  end

end
