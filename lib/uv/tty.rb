module UV
  # uv_tty_t is a subclass of uv_stream_t
  #
  # Representing a stream for the console.
  #
  # ## Fields:
  # :close_cb ::
  #   (Proc(callback_close_cb))
  # :data ::
  #   (FFI::Pointer(*Void))
  # :loop ::
  #   (Loop)
  # :type ::
  #   (Symbol from `enum_handle_type`)
  # :handle_queue ::
  #   (Array<FFI::Pointer(*Void)>)
  # :flags ::
  #   (Integer)
  # :next_closing ::
  #   (Handle)
  # :write_queue_size ::
  #   (Integer)
  # :alloc_cb ::
  #   (Proc(callback_alloc_cb))
  # :read_cb ::
  #   (Proc(callback_read_cb))
  # :read2_cb ::
  #   (Proc(callback_read2_cb))
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
    layout :close_cb, :close_cb,
           :data, :pointer,
           :loop, Loop.by_ref,
           :type, :handle_type,
           :handle_queue, [:pointer, 2],
           :flags, :int,
           :next_closing, Handle.by_ref,
           :write_queue_size, :ulong,
           :alloc_cb, :alloc_cb,
           :read_cb, :read_cb,
           :read2_cb, :read2_cb,
           :connect_req, Connect.by_ref,
           :shutdown_req, Shutdown.by_ref,
           :io_watcher, Io.by_value,
           :write_queue, [:pointer, 2],
           :write_completed_queue, [:pointer, 2],
           :connection_cb, :connection_cb,
           :delayed_error, :int,
           :accepted_fd, :int,
           :select, :pointer,
           # :orig_termios, :termios,
           :mode, :int
  end

end
