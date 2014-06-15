module UV
  # uv_getaddrinfo_t is a subclass of uv_req_t
  #
  # Request object for uv_getaddrinfo.
  #
  # ## Fields:
  # :data ::
  #   (FFI::Pointer(*Void))
  # :type ::
  #   (Symbol from `enum_req_type`)
  # :active_queue ::
  #   (Array<FFI::Pointer(*Void)>)
  # :loop ::
  #   (Loop) read-only
  # :work_req ::
  #   (Work)
  # :cb ::
  #   (Proc(callback_getaddrinfo_cb))
  # :hints ::
  #   (FFI::Pointer(*Addrinfo))
  # :hostname ::
  #   (String)
  # :service ::
  #   (String)
  # :res ::
  #   (FFI::Pointer(*Addrinfo))
  # :retcode ::
  #   (Integer)
  class Getaddrinfo < FFI::Struct
    layout :data, :pointer,
           :type, :req_type,
           :active_queue, [:pointer, 2],
           :loop, Loop,
           :work_req, Work.by_value,
           :cb, :getaddrinfo_cb,
           :hints, :pointer,
           :hostname, :string,
           :service, :string,
           :res, :pointer,
           :retcode, :int
  end

end
