module UV
  # (Not documented)
  #
  # ## Fields:
  # :address4 ::
  #   (unknown)
  # :address6 ::
  #   (unknown)
  class InterfaceAddressAddress < FFI::Union
    layout :address4, :char,
           :address6, :char
  end

end
