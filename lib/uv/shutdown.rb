module UV
  # (Not documented)
  #
  # ## Fields:
  # :data ::
  #   (FFI::Pointer(*Void))
  # :type ::
  #   (Symbol from `enum_req_type`)
  # :active_queue ::
  #   (Array<FFI::Pointer(*Void)>)
  # :handle ::
  #   (Stream)
  # :cb ::
  #   (Proc(callback_shutdown_cb))
  module ShutdownWrappers
    # @param [Stream] handle
    # @param [Proc(callback_shutdown_cb)] cb
    # @return [Integer]
    def shutdown(handle, cb)
      UV.shutdown(self, handle, cb)
    end
  end

  class Shutdown < FFI::Struct
    include ShutdownWrappers
    layout :data, :pointer,
           :type, :req_type,
           :active_queue, [:pointer, 2],
           :handle, Stream,
           :cb, :shutdown_cb
  end

end
