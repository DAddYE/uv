module UV
  # (Not documented)
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
  # :path ::
  #   (String) private
  # :cb ::
  #   (Proc(callback_fs_event_cb))
  # :event_watcher ::
  #   (Io)
  # :realpath ::
  #   (String)
  # :realpath_len ::
  #   (Integer)
  # :cf_flags ::
  #   (Integer)
  # :cf_cb ::
  #   (Async)
  # :cf_events ::
  #   (Array<FFI::Pointer(*Void)>)
  # :cf_member ::
  #   (Array<FFI::Pointer(*Void)>)
  # :cf_error ::
  #   (Integer)
  # :cf_mutex ::
  #   (unknown)
  module FsEventWrappers
    # @param [Proc(callback_fs_event_cb)] cb
    # @param [String] path
    # @param [Integer] flags
    # @return [Integer]
    def start(cb, path, flags)
      UV.fs_event_start(self, cb, path, flags)
    end

    # @return [Integer]
    def stop()
      UV.fs_event_stop(self)
    end

    # @param [String] buf
    # @param [FFI::Pointer(*Size)] len
    # @return [Integer]
    def getpath(buf, len)
      UV.fs_event_getpath(self, buf, len)
    end
  end

  class FsEvent < FFI::Struct
    include FsEventWrappers
    layout :data, :pointer,
           :loop, Loop.by_ref,
           :type, :handle_type,
           :close_cb, :close_cb,
           :handle_queue, [:pointer, 2],
           :next_closing, Handle.by_ref,
           :flags, :uint,
           :path, :string,
           :cb, :fs_event_cb,
           :event_watcher, Io.by_value,
           :realpath, :string,
           :realpath_len, :int,
           :cf_flags, :int,
           :cf_cb, Async.by_ref,
           :cf_events, [:pointer, 2],
           :cf_member, [:pointer, 2],
           :cf_error, :int,
           :cf_mutex, :unknown
  end

end
