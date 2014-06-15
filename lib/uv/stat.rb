module UV
  # (Not documented)
  #
  # ## Fields:
  # :st_dev ::
  #   (Integer)
  # :st_mode ::
  #   (Integer)
  # :st_nlink ::
  #   (Integer)
  # :st_uid ::
  #   (Integer)
  # :st_gid ::
  #   (Integer)
  # :st_rdev ::
  #   (Integer)
  # :st_ino ::
  #   (Integer)
  # :st_size ::
  #   (Integer)
  # :st_blksize ::
  #   (Integer)
  # :st_blocks ::
  #   (Integer)
  # :st_flags ::
  #   (Integer)
  # :st_gen ::
  #   (Integer)
  # :st_atim ::
  #   (Timespec)
  # :st_mtim ::
  #   (Timespec)
  # :st_ctim ::
  #   (Timespec)
  # :st_birthtim ::
  #   (Timespec)
  class Stat < FFI::Struct
    layout :st_dev, :ulong_long,
           :st_mode, :ulong_long,
           :st_nlink, :ulong_long,
           :st_uid, :ulong_long,
           :st_gid, :ulong_long,
           :st_rdev, :ulong_long,
           :st_ino, :ulong_long,
           :st_size, :ulong_long,
           :st_blksize, :ulong_long,
           :st_blocks, :ulong_long,
           :st_flags, :ulong_long,
           :st_gen, :ulong_long,
           :st_atim, Timespec.by_value,
           :st_mtim, Timespec.by_value,
           :st_ctim, Timespec.by_value,
           :st_birthtim, Timespec.by_value
  end

end
