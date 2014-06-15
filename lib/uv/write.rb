module UV
  # uv_write_t is a subclass of uv_req_t
  #
  # ## Fields:
  # :data ::
  #   (FFI::Pointer(*Void))
  # :type ::
  #   (Symbol from `enum_req_type`)
  # :active_queue ::
  #   (Array<FFI::Pointer(*Void)>)
  # :cb ::
  #   (Proc(callback_write_cb))
  # :send_handle ::
  #   (Stream)
  # :handle ::
  #   (Stream)
  # :queue ::
  #   (Array<FFI::Pointer(*Void)>)
  # :write_index ::
  #   (Integer)
  # :bufs ::
  #   (Buf)
  # :nbufs ::
  #   (Integer)
  # :error ::
  #   (Integer)
  # :bufsml ::
  #   (Array<Buf>)
  module WriteWrappers
    # @param [Stream] handle
    # @param [Array<unknown>] bufs
    # @param [Integer] nbufs
    # @param [Proc(callback_write_cb)] cb
    # @return [Integer]
    def write(handle, bufs, nbufs, cb)
      UV.write(self, handle, bufs, nbufs, cb)
    end
  end

  class Write < FFI::Struct
    include WriteWrappers
    layout :data, :pointer,
           :type, :req_type,
           :active_queue, [:pointer, 2],
           :cb, :write_cb,
           :send_handle, Stream.by_ref,
           :handle, Stream.by_ref,
           :queue, [:pointer, 2],
           :write_index, :uint,
           :bufs, Buf.by_ref,
           :nbufs, :uint,
           :error, :int,
           :bufsml, [Buf.by_value, 4]
  end

end
