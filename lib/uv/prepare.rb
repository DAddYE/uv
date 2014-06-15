module UV
  # uv_prepare_t is a subclass of uv_handle_t.
  #
  # Every active prepare handle gets its callback called exactly once per loop
  # iteration, just before the system blocks to wait for completed i/o.
  #
  # ## Fields:
  # :data ::
  #   (FFI::Pointer(*Void))
  # :loop ::
  #   (Loop)
  # :type ::
  #   (Symbol from `enum_handle_type`)
  # :close_cb ::
  #   (Proc(callback_close_cb))
  # :handle_queue ::
  #   (Array<FFI::Pointer(*Void)>)
  # :next_closing ::
  #   (Handle)
  # :flags ::
  #   (Integer)
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
    layout :data, :pointer,
           :loop, Loop.by_ref,
           :type, :handle_type,
           :close_cb, :close_cb,
           :handle_queue, [:pointer, 2],
           :next_closing, Handle.by_ref,
           :flags, :uint,
           :prepare_cb, :prepare_cb,
           :queue, [:pointer, 2]
  end

end
