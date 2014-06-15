module UV
  # (Not documented)
  #
  # ## Fields:
  # :address4 ::
  #   (unknown)
  # :address6 ::
  #   (unknown)
  class InterfaceAddressAddress < FFI::Union
    layout :address4, :sockaddr_in,
           :address6, :sockaddr_in6
  end

end
