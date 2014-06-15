module UV
  # (Not documented)
  #
  # ## Fields:
  # :name ::
  #   (String)
  # :phys_addr ::
  #   (Array<Integer>)
  # :is_internal ::
  #   (Integer)
  # :address ::
  #   (InterfaceAddressAddress)
  # :netmask ::
  #   (InterfaceAddressNetmask)
  class InterfaceAddress < FFI::Struct
    layout :name, :string,
           :phys_addr, [:char, 6],
           :is_internal, :int,
           :address, InterfaceAddressAddress.by_value,
           :netmask, InterfaceAddressNetmask.by_value
  end

end
