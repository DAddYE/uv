module UV
  # (Not documented)
  #
  # ## Fields:
  # :netmask4 ::
  #   (unknown)
  # :netmask6 ::
  #   (unknown)
  class InterfaceAddressNetmask < FFI::Union
    layout :netmask4, :sockaddr_in,
           :netmask6, :sockaddr_in6
  end

end
