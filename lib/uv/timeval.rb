module UV
  # (Not documented)
  #
  # ## Fields:
  # :tv_sec ::
  #   (Integer)
  # :tv_usec ::
  #   (Integer)
  class Timeval < FFI::Struct
    layout :tv_sec, :long,
           :tv_usec, :long
  end

end
