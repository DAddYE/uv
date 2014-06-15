module UV
  # (Not documented)
  #
  # ## Fields:
  # :ru_utime ::
  #   (Timeval) user CPU time used
  # :ru_stime ::
  #   (Timeval) system CPU time used
  # :ru_maxrss ::
  #   (Integer) maximum resident set size
  # :ru_ixrss ::
  #   (Integer) integral shared memory size
  # :ru_idrss ::
  #   (Integer) integral unshared data size
  # :ru_isrss ::
  #   (Integer) integral unshared stack size
  # :ru_minflt ::
  #   (Integer) page reclaims (soft page faults)
  # :ru_majflt ::
  #   (Integer) page faults (hard page faults)
  # :ru_nswap ::
  #   (Integer) swaps
  # :ru_inblock ::
  #   (Integer) block input operations
  # :ru_oublock ::
  #   (Integer) block output operations
  # :ru_msgsnd ::
  #   (Integer) IPC messages sent
  # :ru_msgrcv ::
  #   (Integer) IPC messages received
  # :ru_nsignals ::
  #   (Integer) signals received
  # :ru_nvcsw ::
  #   (Integer) voluntary context switches
  # :ru_nivcsw ::
  #   (Integer) involuntary context switches
  class Rusage < FFI::Struct
    layout :ru_utime, Timeval.by_value,
           :ru_stime, Timeval.by_value,
           :ru_maxrss, :ulong_long,
           :ru_ixrss, :ulong_long,
           :ru_idrss, :ulong_long,
           :ru_isrss, :ulong_long,
           :ru_minflt, :ulong_long,
           :ru_majflt, :ulong_long,
           :ru_nswap, :ulong_long,
           :ru_inblock, :ulong_long,
           :ru_oublock, :ulong_long,
           :ru_msgsnd, :ulong_long,
           :ru_msgrcv, :ulong_long,
           :ru_nsignals, :ulong_long,
           :ru_nvcsw, :ulong_long,
           :ru_nivcsw, :ulong_long
  end

end
