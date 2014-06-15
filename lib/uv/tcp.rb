module UV
  # uv_tcp_t is a subclass of uv_stream_t
  #
  # Represents a TCP stream or TCP server.
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
  module TcpWrappers
    # @param [Integer] sock
    # @return [Integer]
    def open(sock)
      UV.tcp_open(self, sock)
    end

    # @param [Integer] enable
    # @return [Integer]
    def nodelay(enable)
      UV.tcp_nodelay(self, enable)
    end

    # @param [Integer] enable
    # @param [Integer] delay
    # @return [Integer]
    def keepalive(enable, delay)
      UV.tcp_keepalive(self, enable, delay)
    end

    # @param [Integer] enable
    # @return [Integer]
    def simultaneous_accepts(enable)
      UV.tcp_simultaneous_accepts(self, enable)
    end

    # @param [unknown] unknown
    # @return [Integer]
    def bind(unknown)
      UV.tcp_bind(self, unknown)
    end

    # @param [unknown] unknown
    # @return [Integer]
    def bind6(unknown)
      UV.tcp_bind6(self, unknown)
    end

    # @param [FFI::Pointer(*Sockaddr)] name
    # @param [FFI::Pointer(*Int)] namelen
    # @return [Integer]
    def getsockname(name, namelen)
      UV.tcp_getsockname(self, name, namelen)
    end

    # @param [FFI::Pointer(*Sockaddr)] name
    # @param [FFI::Pointer(*Int)] namelen
    # @return [Integer]
    def getpeername(name, namelen)
      UV.tcp_getpeername(self, name, namelen)
    end
  end

  class Tcp < FFI::Struct
    include TcpWrappers
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
           :select, :pointer
  end

end
