module UV
  # (Not documented)
  #
  # ## Fields:
  # :req ::
  #   (Req)
  # :connect ::
  #   (Connect)
  # :write ::
  #   (Write)
  # :shutdown ::
  #   (Shutdown)
  # :udp_send ::
  #   (UdpSend)
  # :fs ::
  #   (Fs)
  # :work ::
  #   (Work)
  # :getaddrinfo ::
  #   (Getaddrinfo)
  class AnyReq < FFI::Union
    layout :req, Req.by_value,
           :connect, Connect.by_value,
           :write, Write.by_value,
           :shutdown, Shutdown.by_value,
           :udp_send, UdpSend.by_value,
           :fs, Fs.by_value,
           :work, Work.by_value,
           :getaddrinfo, Getaddrinfo.by_value
  end

end
