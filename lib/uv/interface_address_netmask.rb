module UV
  # (Not documented)
  #
  # ## Fields:
  # :netmask4 ::
  #   (unknown)
  # :netmask6 ::
  #   (unknown)
  class InterfaceAddressNetmask < FFI::Union
    layout :netmask4, :char,
           :netmask6, :char
  end

end
