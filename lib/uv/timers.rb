module UV
  # (Not documented)
  #
  # ## Fields:
  # :rbh_root ::
  #   (Timer)
  class Timers < FFI::Struct
    layout :rbh_root, Timer
  end

end
