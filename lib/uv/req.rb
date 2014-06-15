module UV
  # Request types.
  # Abstract base class of all requests.
  #
  # ## Fields:
  # :data ::
  #   (FFI::Pointer(*Void))
  # :type ::
  #   (Symbol from `enum_req_type`)
  # :active_queue ::
  #   (Array<FFI::Pointer(*Void)>)
  class Req < FFI::Struct
    layout :data, :pointer,
           :type, :req_type,
           :active_queue, [:pointer, 2]
  end

end
