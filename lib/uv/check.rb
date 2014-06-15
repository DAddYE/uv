module UV
  # uv_check_t is a subclass of uv_handle_t.
  #
  # Every active check handle gets its callback called exactly once per loop
  # iteration, just after the system returns from blocking.
  #
  # ## Fields:
  # :close_cb ::
  #   (Proc(callback_close_cb))
  # :data ::
  #   (FFI::Pointer(*Void))
  # :loop ::
  #   (Loop)
  # :type ::
  #   (Symbol from `enum_handle_type`)
  # :handle_queue ::
  #   (Array<FFI::Pointer(*Void)>)
  # :flags ::
  #   (Integer)
  # :next_closing ::
  #   (Handle)
  # :check_cb ::
  #   (Proc(callback_check_cb))
  # :queue ::
  #   (Array<FFI::Pointer(*Void)>)
  module CheckWrappers
    # @param [Proc(callback_check_cb)] cb
    # @return [Integer]
    def start(cb)
      UV.check_start(self, cb)
    end

    # @return [Integer]
    def stop()
      UV.check_stop(self)
    end
  end

  class Check < FFI::Struct
    include CheckWrappers
    layout :close_cb, :close_cb,
           :data, :pointer,
           :loop, Loop.by_ref,
           :type, :handle_type,
           :handle_queue, [:pointer, 2],
           :flags, :int,
           :next_closing, Handle.by_ref,
           :check_cb, :check_cb,
           :queue, [:pointer, 2]
  end

end
