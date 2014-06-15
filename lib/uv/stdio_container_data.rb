module UV
  # (Not documented)
  #
  # ## Fields:
  # :stream ::
  #   (Stream)
  # :fd ::
  #   (Integer)
  class StdioContainerData < FFI::Union
    layout :stream, Stream,
           :fd, :int
  end

end
