module UV
  # Note: May be cast to struct iovec. See writev(2).
  #
  # ## Fields:
  # :base ::
  #   (String)
  # :len ::
  #   (Integer)
  class Buf < FFI::Struct
    layout :base, :pointer,
           :len, :ulong
  end

end
