module UV
  # uv_timer_t is a subclass of uv_handle_t.
  #
  # Used to get woken up at a specified time in the future.
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
  # :tree_entry ::
  #   (TimerTreeEntry)
  # :timer_cb ::
  #   (Proc(callback_timer_cb))
  # :timeout ::
  #   (Integer)
  # :repeat ::
  #   (Integer)
  # :start_id ::
  #   (Integer)
  module TimerWrappers
    # @param [Proc(callback_timer_cb)] cb
    # @param [Integer] timeout
    # @param [Integer] repeat
    # @return [Integer]
    def start(cb, timeout, repeat)
      UV.timer_start(self, cb, timeout, repeat)
    end

    # @return [Integer]
    def stop()
      UV.timer_stop(self)
    end

    # @return [Integer]
    def again()
      UV.timer_again(self)
    end

    # @param [Integer] repeat
    # @return [nil]
    def set_repeat(repeat)
      UV.timer_set_repeat(self, repeat)
    end

    # @return [Integer]
    def get_repeat()
      UV.timer_get_repeat(self)
    end
  end

  class Timer < FFI::Struct
    include TimerWrappers
    layout :close_cb, :close_cb,
           :data, :pointer,
           :loop, :pointer,
           :type, :handle_type,
           :handle_queue, [:pointer, 2],
           :flags, :int,
           :next_closing, Handle,
           :tree_entry, TimerTreeEntry.by_value,
           :timer_cb, :timer_cb,
           :timeout, :ulong_long,
           :repeat, :ulong_long,
           :start_id, :ulong_long
  end

end
