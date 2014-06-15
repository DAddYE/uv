module UV
  # uv_stream_t is a subclass of uv_handle_t
  #
  # uv_stream is an abstract class.
  #
  # uv_stream_t is the parent class of uv_tcp_t, uv_pipe_t, uv_tty_t, and
  # soon uv_file_t.
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
  module StreamWrappers
    # @param [Integer] blocking
    # @return [Integer]
    def set_blocking(blocking)
      UV.stream_set_blocking(self, blocking)
    end
  end

  class Stream < FFI::Struct
    include StreamWrappers
    layout :close_cb, :close_cb,
           :data, :pointer,
           :loop, Loop,
           :type, :handle_type,
           :handle_queue, [:pointer, 2],
           :flags, :int,
           :next_closing, Handle,
           :write_queue_size, :ulong,
           :alloc_cb, :alloc_cb,
           :read_cb, :read_cb,
           :read2_cb, :read2_cb,
           :connect_req, :pointer, # Connect,
           :shutdown_req, :pointer, # Shutdown,
           :io_watcher, Io.by_value,
           :write_queue, [:pointer, 2],
           :write_completed_queue, [:pointer, 2],
           :connection_cb, :connection_cb,
           :delayed_error, :int,
           :accepted_fd, :int,
           :select, :pointer
  end

end
