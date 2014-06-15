module UV
  # (Not documented)
  #
  # ## Fields:
  # :work ::
  #   (FFI::Pointer(*))
  # :done ::
  #   (FFI::Pointer(*))
  # :loop ::
  #   (Loop)
  # :wq ::
  #   (Array<FFI::Pointer(*Void)>)
  class Work < FFI::Struct
    layout :work, :pointer,
           :done, :pointer,
           :loop, Loop.by_ref,
           :wq, [:pointer, 2]
  end

end
