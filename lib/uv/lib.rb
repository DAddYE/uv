module UV
  # empty
  #
  # ## Fields:
  # :handle ::
  #   (FFI::Pointer(*Void))
  # :errmsg ::
  #   (String)
  class Lib < FFI::Struct
    layout :handle, :pointer,
           :errmsg, :string
  end

end
