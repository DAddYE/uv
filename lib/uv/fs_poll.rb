module UV
  # uv_fs_stat() based polling file watcher.
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

    # @param [String] buf
    # @param [FFI::Pointer(*Size)] len
    # @return [Integer]
    def getpath(buf, len)
      UV.fs_poll_getpath(self, buf, len)
    end
  end

  class FsPoll < FFI::Struct
    include FsPollWrappers
    layout :data, :pointer,
           :loop, Loop.by_ref,
           :type, :handle_type,
           :close_cb, :close_cb,
           :handle_queue, [:pointer, 2],
           :next_closing, Handle.by_ref,
           :flags, :uint,
           :poll_ctx, :pointer
  end

end
