module UV
  # (Not documented)
  #
  # ## Fields:
  # :min ::
  #   (FFI::Pointer(*Void))
  # :nelts ::
  #   (Integer)
  class LoopTimerHeap < FFI::Struct
    layout :min, :pointer,
           :nelts, :uint
  end

end
