module UV
  # UNIX signal handling on a per-event loop basis. The implementation is not
  # ultra efficient so don't go creating a million event loops with a million
  # signal watchers.
  #
  # Note to Linux users: SIGRT0 and SIGRT1 (signals 32 and 33) are used by the
  # NPTL pthreads library to manage threads. Installing watchers for those
  # signals will lead to unpredictable behavior and is strongly discouraged.
  # Future versions of libuv may simply reject them.
  #
  # Reception of some signals is emulated on Windows:
  #
  #   SIGINT is normally delivered when the user presses CTRL+C. However, like
  #   on Unix, it is not generated when terminal raw mode is enabled.
  #
  #   SIGBREAK is delivered when the user pressed CTRL+BREAK.
  #
  #   SIGHUP is generated when the user closes the console window. On SIGHUP the
  #   program is given approximately 10 seconds to perform cleanup. After that
  #   Windows will unconditionally terminate it.
  #
  #   SIGWINCH is raised whenever libuv detects that the console has been
  #   resized. SIGWINCH is emulated by libuv when the program uses an uv_tty_t
  #   handle to write to the console. SIGWINCH may not always be delivered in a
  #   timely manner; libuv will only detect size changes when the cursor is
  #   being moved. When a readable uv_tty_handle is used in raw mode, resizing
  #   the console buffer will also trigger a SIGWINCH signal.
  #
  # Watchers for other signals can be successfully created, but these signals
  # are never received. These signals are: SIGILL, SIGABRT, SIGFPE, SIGSEGV,
  # SIGTERM and SIGKILL.
  #
  # Note that calls to raise() or abort() to programmatically raise a signal are
  # not detected by libuv; these will not trigger a signal watcher.
  #
  # See uv_process_kill() and uv_kill() for information about support for sending
  # signals.
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
  # :signal_cb ::
  #   (Proc(callback_signal_cb))
  # :signum ::
  #   (Integer)
  # :tree_entry ::
  #   (SignalTreeEntry)
  # :caught_signals ::
  #   (Integer)
  # :dispatched_signals ::
  #   (Integer)
  module SignalWrappers
    # @param [Proc(callback_signal_cb)] signal_cb
    # @param [Integer] signum
    # @return [Integer]
    def start(signal_cb, signum)
      UV.signal_start(self, signal_cb, signum)
    end

    # @return [Integer]
    def stop()
      UV.signal_stop(self)
    end
  end

  class Signal < FFI::Struct
    include SignalWrappers
    layout :data, :pointer,
           :loop, Loop.by_ref,
           :type, :handle_type,
           :close_cb, :close_cb,
           :handle_queue, [:pointer, 2],
           :next_closing, Handle.by_ref,
           :flags, :uint,
           :signal_cb, :signal_cb,
           :signum, :int,
           :tree_entry, SignalTreeEntry.by_value,
           :caught_signals, :uint,
           :dispatched_signals, :uint
  end

end
