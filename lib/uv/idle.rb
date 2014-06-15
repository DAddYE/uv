module UV
  # uv_idle_t is a subclass of uv_handle_t.
  #
  # Every active idle handle gets its callback called repeatedly until it is
  # stopped. This happens after all other types of callbacks are processed.
  # When there are multiple "idle" handles active, their callbacks are called
  # in turn.
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
  # :idle_cb ::
  #   (Proc(callback_idle_cb))
  # :queue ::
  #   (Array<FFI::Pointer(*Void)>)
  module IdleWrappers
    # @param [Proc(callback_idle_cb)] cb
    # @return [Integer]
    def start(cb)
      UV.idle_start(self, cb)
    end

    # @return [Integer]
    def stop()
      UV.idle_stop(self)
    end
  end

  class Idle < FFI::Struct
    include IdleWrappers
    layout :close_cb, :close_cb,
           :data, :pointer,
           :loop, Loop,
           :type, :handle_type,
           :handle_queue, [:pointer, 2],
           :flags, :int,
           :next_closing, Handle,
           :idle_cb, :idle_cb,
           :queue, [:pointer, 2]
  end

end
