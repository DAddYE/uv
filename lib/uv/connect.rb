module UV
  # uv_connect_t is a subclass of uv_req_t
  #
  # ## Fields:
  # :data ::
  #   (FFI::Pointer(*Void))
  # :type ::
  #   (Symbol from `enum_req_type`)
  # :active_queue ::
  #   (Array<FFI::Pointer(*Void)>)
  # :cb ::
  #   (Proc(callback_connect_cb))
  # :handle ::
  #   (Stream)
  # :queue ::
  #   (Array<FFI::Pointer(*Void)>)
  class Connect < FFI::Struct
    layout :data, :pointer,
           :type, :req_type,
           :active_queue, [:pointer, 2],
           :cb, :connect_cb,
           :handle, Stream,
           :queue, [:pointer, 2]
  end

end
