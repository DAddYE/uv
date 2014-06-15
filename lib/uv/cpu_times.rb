module UV
  # (Not documented)
  #
  # ## Fields:
  # :user ::
  #   (Integer)
  # :nice ::
  #   (Integer)
  # :sys ::
  #   (Integer)
  # :idle ::
  #   (Integer)
  # :irq ::
  #   (Integer)
  class CpuTimes < FFI::Struct
    layout :user, :ulong_long,
           :nice, :ulong_long,
           :sys, :ulong_long,
           :idle, :ulong_long,
           :irq, :ulong_long
  end

end
