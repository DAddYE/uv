module UV
  # uv_tcp_t is a subclass of uv_stream_t
  #
  # Represents a TCP stream or TCP server.
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

    # @param [FFI::Pointer(*Sockaddr)] addr
    # @param [Integer] flags
    # @return [Integer]
    def bind(addr, flags)
      UV.tcp_bind(self, addr, flags)
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
           :select, :pointer
  end

end
