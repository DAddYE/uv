module UV
  # uv_udp_t is a subclass of uv_handle_t
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
  # :alloc_cb ::
  #   (Proc(callback_alloc_cb))
  # :recv_cb ::
  #   (Proc(callback_udp_recv_cb))
  # :io_watcher ::
  #   (Io)
  # :write_queue ::
  #   (Array<FFI::Pointer(*Void)>)
  # :write_completed_queue ::
  #   (Array<FFI::Pointer(*Void)>)
  module UdpWrappers
    # @param [Integer] sock
    # @return [Integer]
    def open(sock)
      UV.udp_open(self, sock)
    end

    # @param [unknown] addr
    # @param [Integer] flags
    # @return [Integer]
    def bind(addr, flags)
      UV.udp_bind(self, addr, flags)
    end

    # @param [unknown] addr
    # @param [Integer] flags
    # @return [Integer]
    def bind6(addr, flags)
      UV.udp_bind6(self, addr, flags)
    end

    # @param [FFI::Pointer(*Sockaddr)] name
    # @param [FFI::Pointer(*Int)] namelen
    # @return [Integer]
    def getsockname(name, namelen)
      UV.udp_getsockname(self, name, namelen)
    end

    # @param [String] multicast_addr
    # @param [String] interface_addr
    # @param [Symbol from `enum_membership`] membership
    # @return [Integer]
    def set_membership(multicast_addr, interface_addr, membership)
      UV.udp_set_membership(self, multicast_addr, interface_addr, membership)
    end

    # @param [Integer] on
    # @return [Integer]
    def set_multicast_loop(on)
      UV.udp_set_multicast_loop(self, on)
    end

    # @param [Integer] ttl
    # @return [Integer]
    def set_multicast_ttl(ttl)
      UV.udp_set_multicast_ttl(self, ttl)
    end

    # @param [Integer] on
    # @return [Integer]
    def set_broadcast(on)
      UV.udp_set_broadcast(self, on)
    end

    # @param [Integer] ttl
    # @return [Integer]
    def set_ttl(ttl)
      UV.udp_set_ttl(self, ttl)
    end

    # @param [Proc(callback_alloc_cb)] alloc_cb
    # @param [Proc(callback_udp_recv_cb)] recv_cb
    # @return [Integer]
    def recv_start(alloc_cb, recv_cb)
      UV.udp_recv_start(self, alloc_cb, recv_cb)
    end

    # @return [Integer]
    def recv_stop()
      UV.udp_recv_stop(self)
    end
  end

  class Udp < FFI::Struct
    include UdpWrappers
    layout :close_cb, :close_cb,
           :data, :pointer,
           :loop, Loop,
           :type, :handle_type,
           :handle_queue, [:pointer, 2],
           :flags, :int,
           :next_closing, Handle,
           :alloc_cb, :alloc_cb,
           :recv_cb, :udp_recv_cb,
           :io_watcher, Io.by_value,
           :write_queue, [:pointer, 2],
           :write_completed_queue, [:pointer, 2]
  end

end
