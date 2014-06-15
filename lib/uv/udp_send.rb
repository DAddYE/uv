module UV
  # uv_udp_send_t is a subclass of uv_req_t
  #
  # ## Fields:
  # :data ::
  #   (FFI::Pointer(*Void))
  # :type ::
  #   (Symbol from `enum_req_type`)
  # :active_queue ::
  #   (Array<FFI::Pointer(*Void)>)
  # :handle ::
  #   (Udp)
  # :cb ::
  #   (Proc(callback_udp_send_cb))
  # :queue ::
  #   (Array<FFI::Pointer(*Void)>)
  # :addr ::
  #   (unknown)
  # :nbufs ::
  #   (Integer)
  # :bufs ::
  #   (Buf)
  # :status ::
  #   (Integer)
  # :send_cb ::
  #   (Proc(callback_udp_send_cb))
  # :bufsml ::
  #   (Array<Buf>)
  module UdpSendWrappers
    # @param [Udp] handle
    # @param [Array<unknown>] bufs
    # @param [Integer] nbufs
    # @param [FFI::Pointer(*Sockaddr)] addr
    # @param [Proc(callback_udp_send_cb)] send_cb
    # @return [Integer]
    def udp_send(handle, bufs, nbufs, addr, send_cb)
      UV.udp_send(self, handle, bufs, nbufs, addr, send_cb)
    end
  end

  class UdpSend < FFI::Struct
    include UdpSendWrappers
    layout :data, :pointer,
           :type, :req_type,
           :active_queue, [:pointer, 2],
           :handle, Udp.by_ref,
           :cb, :udp_send_cb,
           :queue, [:pointer, 2],
           :addr, :unknown,
           :nbufs, :uint,
           :bufs, Buf.by_ref,
           :status, :long,
           :send_cb, :udp_send_cb,
           :bufsml, [Buf.by_value, 4]
  end

end
