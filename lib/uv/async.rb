module UV
  # uv_async_t is a subclass of uv_handle_t.
  #
  # uv_async_send wakes up the event loop and calls the async handle's callback.
  # There is no guarantee that every uv_async_send call leads to exactly one
  # invocation of the callback; the only guarantee is that the callback function
  # is called at least once after the call to async_send. Unlike all other
  # libuv functions, uv_async_send can be called from another thread.
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
  # :async_cb ::
  #   (Proc(callback_async_cb))
  # :queue ::
  #   (Array<FFI::Pointer(*Void)>)
  # :pending ::
  #   (Integer)
  module AsyncWrappers
    # @return [Integer]
    def send()
      UV.async_send(self)
    end
  end

  class Async < FFI::Struct
    include AsyncWrappers
    layout :data, :pointer,
           :loop, Loop.by_ref,
           :type, :handle_type,
           :close_cb, :close_cb,
           :handle_queue, [:pointer, 2],
           :next_closing, Handle.by_ref,
           :flags, :uint,
           :async_cb, :async_cb,
           :queue, [:pointer, 2],
           :pending, :int
  end

end
