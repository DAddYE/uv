module UV
  # uv_tty_t is a subclass of uv_stream_t
  #
  # Representing a stream for the console.
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
  # :write_queue_size ::
  #   (Integer)
  # :alloc_cb ::
  #   (Proc(callback_alloc_cb))
  # :read_cb ::
  #   (Proc(callback_read_cb))
  # :connect_req ::
  #   (Connect)
  # :shutdown_req ::
  #   (Shutdown)
  # :io_watcher ::
  #   (Io)
  # :write_queue ::
  #   (Array<FFI::Pointer(*Void)>)
  # :write_completed_queue ::
  #   (Array<FFI::Pointer(*Void)>)
  # :connection_cb ::
  #   (Proc(callback_connection_cb))
  # :delayed_error ::
  #   (Integer)
  # :accepted_fd ::
  #   (Integer)
  # :queued_fds ::
  #   (FFI::Pointer(*Void))
  # :select ::
  #   (FFI::Pointer(*Void))
  # :orig_termios ::
  #   (unknown)
  # :mode ::
  #   (Integer)
  module TtyWrappers
    # @param [Integer] mode
    # @return [Integer]
    def set_mode(mode)
      UV.tty_set_mode(self, mode)
    end

    # @param [FFI::Pointer(*Int)] width
    # @param [FFI::Pointer(*Int)] height
    # @return [Integer]
    def get_winsize(width, height)
      UV.tty_get_winsize(self, width, height)
    end
  end

  class Tty < FFI::Struct
    include TtyWrappers
    layout :data, :pointer,
           :loop, Loop.by_ref,
           :type, :handle_type,
           :close_cb, :close_cb,
           :handle_queue, [:pointer, 2],
           :next_closing, Handle.by_ref,
           :flags, :uint,
           :write_queue_size, :ulong,
           :alloc_cb, :alloc_cb,
           :read_cb, :read_cb,
           :connect_req, Connect.by_ref,
           :shutdown_req, Shutdown.by_ref,
           :io_watcher, Io.by_value,
           :write_queue, [:pointer, 2],
           :write_completed_queue, [:pointer, 2],
           :connection_cb, :connection_cb,
           :delayed_error, :int,
           :accepted_fd, :int,
           :queued_fds, :pointer,
           :select, :pointer,
           :orig_termios, :unknown,
           :mode, :int
  end

end
