module UV
  # (Not documented)
  #
  # ## Fields:
  # :tv_sec ::
  #   (Integer)
  # :tv_nsec ::
  #   (Integer)
  class Timespec < FFI::Struct
    layout :tv_sec, :long,
           :tv_nsec, :long
  end

end
