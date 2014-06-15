module UV
  # (Not documented)
  #
  # ## Fields:
  # :cb ::
  #   (Proc(callback_io_cb))
  # :pending_queue ::
  #   (Array<FFI::Pointer(*Void)>)
  # :watcher_queue ::
  #   (Array<FFI::Pointer(*Void)>)
  # :pevents ::
  #   (Integer) Pending event mask i.e. mask at next tick.
  # :events ::
  #   (Integer) Current event mask.
  # :fd ::
  #   (Integer)
  # :rcount ::
  #   (Integer)
  # :wcount ::
  #   (Integer)
  class Io < FFI::Struct
    layout :cb, :io_cb,
           :pending_queue, [:pointer, 2],
           :watcher_queue, [:pointer, 2],
           :pevents, :uint,
           :events, :uint,
           :fd, :int,
           :rcount, :int,
           :wcount, :int
  end

end
