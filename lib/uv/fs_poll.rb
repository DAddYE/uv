module UV
  # uv_fs_stat() based polling file watcher.
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
  # :poll_ctx ::
  #   (FFI::Pointer(*Void)) Private, don't touch.
  module FsPollWrappers
    # @param [Proc(callback_fs_poll_cb)] poll_cb
    # @param [String] path
    # @param [Integer] interval
    # @return [Integer]
    def start(poll_cb, path, interval)
      UV.fs_poll_start(self, poll_cb, path, interval)
    end

    # @return [Integer]
    def stop()
      UV.fs_poll_stop(self)
    end
  end

  class FsPoll < FFI::Struct
    include FsPollWrappers
    layout :close_cb, :close_cb,
           :data, :pointer,
           :loop, Loop.by_ref,
           :type, :handle_type,
           :handle_queue, [:pointer, 2],
           :flags, :int,
           :next_closing, Handle.by_ref,
           :poll_ctx, :pointer
  end

end
