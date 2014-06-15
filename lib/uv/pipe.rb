module UV
  # uv_pipe_t is a subclass of uv_stream_t
  #
  # Representing a pipe stream or pipe server. On Windows this is a Named
  # Pipe. On Unix this is a UNIX domain socket.
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
  # :ipc ::
  #   (Integer)
  # :pipe_fname ::
  #   (String)
  module PipeWrappers
    # @param [Integer] file
    # @return [Integer]
    def open(file)
      UV.pipe_open(self, file)
    end

    # @param [String] name
    # @return [Integer]
    def bind(name)
      UV.pipe_bind(self, name)
    end

    # @param [String] buf
    # @param [FFI::Pointer(*Size)] len
    # @return [Integer]
    def getsockname(buf, len)
      UV.pipe_getsockname(self, buf, len)
    end

    # @param [Integer] count
    # @return [nil]
    def pending_instances(count)
      UV.pipe_pending_instances(self, count)
    end

    # @return [Integer]
    def pending_count()
      UV.pipe_pending_count(self)
    end

    # @return [Symbol from `enum_handle_type`]
    def pending_type()
      UV.pipe_pending_type(self)
    end
  end

  class Pipe < FFI::Struct
    include PipeWrappers
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
           :ipc, :int,
           :pipe_fname, :string
  end

end
