module UV
  # uv_process_t is a subclass of uv_handle_t
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
  # :exit_cb ::
  #   (Proc(callback_exit_cb))
  # :pid ::
  #   (Integer)
  # :queue ::
  #   (Array<FFI::Pointer(*Void)>)
  # :status ::
  #   (Integer)
  module ProcessWrappers
    # @param [Integer] signum
    # @return [Integer]
    def kill(signum)
      UV.process_kill(self, signum)
    end
  end

  class Process < FFI::Struct
    include ProcessWrappers
    layout :data, :pointer,
           :loop, Loop.by_ref,
           :type, :handle_type,
           :close_cb, :close_cb,
           :handle_queue, [:pointer, 2],
           :next_closing, Handle.by_ref,
           :flags, :uint,
           :exit_cb, :exit_cb,
           :pid, :int,
           :queue, [:pointer, 2],
           :status, :int
  end

end
