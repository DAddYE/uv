module UV
  # (Not documented)
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
  # :filename ::
  #   (String)
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
  # :cf_event ::
  #   (FFI::Pointer(*Void))
  # :cf_cb ::
  #   (Async)
  # :cf_member ::
  #   (Array<FFI::Pointer(*Void)>)
  # :cf_reserved ::
  #   (Integer)
  # :cf_mutex ::
  #   (unknown)
  class FsEvent < FFI::Struct
    layout :close_cb, :close_cb,
           :data, :pointer,
           :loop, Loop,
           :type, :handle_type,
           :handle_queue, [:pointer, 2],
           :flags, :int,
           :next_closing, Handle,
           :filename, :string,
           :cb, :fs_event_cb,
           :event_watcher, Io.by_value,
           :realpath, :string,
           :realpath_len, :int,
           :cf_flags, :int,
           :cf_event, :pointer,
           :cf_cb, Async,
           :cf_member, [:pointer, 2],
           :cf_reserved, :uint,
           :cf_mutex, :char
  end

end
