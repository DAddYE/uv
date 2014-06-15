module UV
  # (Not documented)
  #
  # ## Fields:
  # :flags ::
  #   (Symbol from `enum_stdio_flags`)
  # :data ::
  #   (StdioContainerData)
  class StdioContainer < FFI::Struct
    layout :flags, :stdio_flags,
           :data, StdioContainerData.by_value
  end

end
