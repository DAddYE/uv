module UV
  # uv_prepare_t is a subclass of uv_handle_t.
  #
  # Every active prepare handle gets its callback called exactly once per loop
  # iteration, just before the system blocks to wait for completed i/o.
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
  # :prepare_cb ::
  #   (Proc(callback_prepare_cb))
  # :queue ::
  #   (Array<FFI::Pointer(*Void)>)
  module PrepareWrappers
    # @param [Proc(callback_prepare_cb)] cb
    # @return [Integer]
    def start(cb)
      UV.prepare_start(self, cb)
    end

    # @return [Integer]
    def stop()
      UV.prepare_stop(self)
    end
  end

  class Prepare < FFI::Struct
    include PrepareWrappers
    layout :close_cb, :close_cb,
           :data, :pointer,
           :loop, Loop,
           :type, :handle_type,
           :handle_queue, [:pointer, 2],
           :flags, :int,
           :next_closing, Handle,
           :prepare_cb, :prepare_cb,
           :queue, [:pointer, 2]
  end

end
