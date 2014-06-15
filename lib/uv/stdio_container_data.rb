module UV
  # (Not documented)
  #
  # ## Fields:
  # :stream ::
  #   (Stream)
  # :fd ::
  #   (Integer)
  class StdioContainerData < FFI::Union
    layout :stream, Stream.by_ref,
           :fd, :int
  end

end
