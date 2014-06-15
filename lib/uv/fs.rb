module UV
  # uv_fs_t is a subclass of uv_req_t
  #
  # ## Fields:
  # :data ::
  #   (FFI::Pointer(*Void))
  # :type ::
  #   (Symbol from `enum_req_type`)
  # :active_queue ::
  #   (Array<FFI::Pointer(*Void)>)
  # :fs_type ::
  #   (Symbol from `enum_fs_type`)
  # :loop ::
  #   (Loop)
  # :cb ::
  #   (Proc(callback_fs_cb))
  # :result ::
  #   (Integer)
  # :ptr ::
  #   (FFI::Pointer(*Void))
  # :path ::
  #   (String)
  # :statbuf ::
  #   (Stat)
  # :new_path ::
  #   (String)
  # :file ::
  #   (Integer)
  # :flags ::
  #   (Integer)
  # :mode ::
  #   (Integer)
  # :nbufs ::
  #   (Integer)
  # :bufs ::
  #   (Buf)
  # :off ::
  #   (Integer)
  # :uid ::
  #   (Integer)
  # :gid ::
  #   (Integer)
  # :atime ::
  #   (Float)
  # :mtime ::
  #   (Float)
  # :work_req ::
  #   (Work)
  # :bufsml ::
  #   (Array<Buf>)
  module FsWrappers
    # @return [nil]
    def req_cleanup()
      UV.fs_req_cleanup(self)
    end
  end

  class Fs < FFI::Struct
    include FsWrappers
    layout :data, :pointer,
           :type, :req_type,
           :active_queue, [:pointer, 2],
           :fs_type, :fs_type,
           :loop, Loop.by_ref,
           :cb, :fs_cb,
           :result, :long,
           :ptr, :pointer,
           :path, :string,
           :statbuf, Stat.by_value,
           :new_path, :string,
           :file, :int,
           :flags, :int,
           :mode, :ushort,
           :nbufs, :uint,
           :bufs, Buf.by_ref,
           :off, :long_long,
           :uid, :uint,
           :gid, :uint,
           :atime, :double,
           :mtime, :double,
           :work_req, Work.by_value,
           :bufsml, [Buf.by_value, 4]
  end

end
