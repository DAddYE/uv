module UV
  # uv_pipe_t is a subclass of uv_stream_t
  #
  # Representing a pipe stream or pipe server. On Windows this is a Named
  # Pipe. On Unix this is a UNIX domain socket.
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

    # @param [Integer] count
    # @return [nil]
    def pending_instances(count)
      UV.pipe_pending_instances(self, count)
    end
  end

  class Pipe < FFI::Struct
    include PipeWrappers
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
           :ipc, :int,
           :pipe_fname, :string
  end

end
