module UV
  # None of the above.
  #
  # ## Fields:
  # :model ::
  #   (String)
  # :speed ::
  #   (Integer)
  # :cpu_times ::
  #   (CpuTimes)
  class CpuInfo < FFI::Struct
    layout :model, :string,
           :speed, :int,
           :cpu_times, CpuTimes.by_value
  end

end
