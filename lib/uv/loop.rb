module UV
  # (Not documented)
  #
  # ## Fields:
  # :data ::
  #   (FFI::Pointer(*Void)) User data - use this for whatever.
  # :active_handles ::
  #   (Integer) Loop reference counting
  # :handle_queue ::
  #   (Array<FFI::Pointer(*Void)>)
  # :active_reqs ::
  #   (Array<FFI::Pointer(*Void)>)
  # :stop_flag ::
  #   (Integer) Internal flag to signal loop stop
  # :flags ::
  #   (Integer)
  # :backend_fd ::
  #   (Integer)
  # :pending_queue ::
  #   (Array<FFI::Pointer(*Void)>)
  # :watcher_queue ::
  #   (Array<FFI::Pointer(*Void)>)
  # :watchers ::
  #   (FFI::Pointer(**Io))
  # :nwatchers ::
  #   (Integer)
  # :nfds ::
  #   (Integer)
  # :wq ::
  #   (Array<FFI::Pointer(*Void)>)
  # :wq_mutex ::
  #   (unknown)
  # :wq_async ::
  #   (Async)
  # :cloexec_lock ::
  #   (unknown)
  # :closing_handles ::
  #   (Handle)
  # :process_handles ::
  #   (Array<Array<FFI::Pointer(*Void)>>)
  # :prepare_handles ::
  #   (Array<FFI::Pointer(*Void)>)
  # :check_handles ::
  #   (Array<FFI::Pointer(*Void)>)
  # :idle_handles ::
  #   (Array<FFI::Pointer(*Void)>)
  # :async_handles ::
  #   (Array<FFI::Pointer(*Void)>)
  # :async_watcher ::
  #   (Async)
  # :timer_heap ::
  #   (LoopTimerHeap)
  # :timer_counter ::
  #   (Integer)
  # :time ::
  #   (Integer)
  # :signal_pipefd ::
  #   (Array<Integer>)
  # :signal_io_watcher ::
  #   (Io)
  # :child_watcher ::
  #   (Signal)
  # :emfile_fd ::
  #   (Integer)
  # :cf_thread ::
  #   (FFI::Pointer(Thread))
  # :cf_reserved ::
  #   (FFI::Pointer(*Void))
  # :cf_state ::
  #   (FFI::Pointer(*Void))
  # :cf_mutex ::
  #   (unknown)
  # :cf_sem ::
  #   (Integer)
  # :cf_signals ::
  #   (Array<FFI::Pointer(*Void)>)
  module LoopWrappers
    # @return [Integer]
    def init()
      UV.loop_init(self)
    end

    # @return [Integer]
    def close()
      UV.loop_close(self)
    end

    # @return [nil]
    def delete()
      UV.loop_delete(self)
    end

    # @return [Integer]
    def alive()
      UV.loop_alive(self)
    end
  end

  class Loop < FFI::Struct
    include LoopWrappers
    layout :data, :pointer,
           :active_handles, :uint,
           :handle_queue, [:pointer, 2],
           :active_reqs, [:pointer, 2],
           :stop_flag, :uint,
           :flags, :ulong,
           :backend_fd, :int,
           :pending_queue, [:pointer, 2],
           :watcher_queue, [:pointer, 2],
           :watchers, :pointer,
           :nwatchers, :uint,
           :nfds, :uint,
           :wq, [:pointer, 2],
           :wq_mutex, :unknown,
           :wq_async, Async.by_value,
           :cloexec_lock, :unknown,
           :closing_handles, Handle.by_ref,
           :process_handles, [[:pointer, 2], 1],
           :prepare_handles, [:pointer, 2],
           :check_handles, [:pointer, 2],
           :idle_handles, [:pointer, 2],
           :async_handles, [:pointer, 2],
           :async_watcher, Async.by_value,
           :timer_heap, LoopTimerHeap.by_value,
           :timer_counter, :ulong_long,
           :time, :ulong_long,
           :signal_pipefd, [:int, 2],
           :signal_io_watcher, Io.by_value,
           :child_watcher, Signal.by_value,
           :emfile_fd, :int,
           :cf_thread, :pointer,
           :cf_reserved, :pointer,
           :cf_state, :pointer,
           :cf_mutex, :unknown,
           :cf_sem, :uint,
           :cf_signals, [:pointer, 2]
  end

end
