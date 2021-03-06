module UV
  include FFI::Library

  class InAddr < FFI::Struct
    layout :s_addr, :in_addr_t
  end

  class SockaddrIn < FFI::Struct
    layout :sin_len, :uint8,
      :sin_family, :sa_family_t,
      :sin_port, :in_port_t,
      :sin_addr, InAddr,
      :sin_zero, [:char, 8]
  end


  class U6Addr < FFI::Union
    layout :__u6_addr8, [:uint8, 16],
      :__u6_addr16, [:uint16, 8]
  end

  class In6Addr < FFI::Struct
    layout :__u6_addr, U6Addr.by_ref
  end

  class SockaddrIn6 < FFI::Struct
    layout :sin6_len, :uint8,
      :sin6_family, :sa_family_t,
      :sin6_port, :in_port_t,
      :sin6_flowinfo, :uint32,
      :sin6_addr, In6Addr.by_ref,
      :sin6_scope_id, :uint32
  end
end
