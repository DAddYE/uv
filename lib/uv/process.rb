module UV
  # uv_process_t is a subclass of uv_handle_t
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
  # :exit_cb ::
  #   (Proc(callback_exit_cb))
  # :pid ::
  #   (Integer)
  # :queue ::
  #   (Array<FFI::Pointer(*Void)>)
  # :errorno ::
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
    layout :close_cb, :close_cb,
           :data, :pointer,
           :loop, Loop,
           :type, :handle_type,
           :handle_queue, [:pointer, 2],
           :flags, :int,
           :next_closing, Handle,
           :exit_cb, :exit_cb,
           :pid, :int,
           :queue, [:pointer, 2],
           :errorno, :int
  end

end
