module UV
  # The presence of these unions force similar struct layout.
  #
  # ## Fields:
  # :async ::
  #   (Async)
  # :check ::
  #   (Check)
  # :fs_event ::
  #   (FsEvent)
  # :fs_poll ::
  #   (FsPoll)
  # :handle ::
  #   (Handle)
  # :idle ::
  #   (Idle)
  # :pipe ::
  #   (Pipe)
  # :poll ::
  #   (Poll)
  # :prepare ::
  #   (Prepare)
  # :process ::
  #   (Process)
  # :stream ::
  #   (Stream)
  # :tcp ::
  #   (Tcp)
  # :timer ::
  #   (Timer)
  # :tty ::
  #   (Tty)
  # :udp ::
  #   (Udp)
  # :signal ::
  #   (Signal)
  class AnyHandle < FFI::Union
    layout :async, Async.by_value,
           :check, Check.by_value,
           :fs_event, FsEvent.by_value,
           :fs_poll, FsPoll.by_value,
           :handle, Handle.by_value,
           :idle, Idle.by_value,
           :pipe, Pipe.by_value,
           :poll, Poll.by_value,
           :prepare, Prepare.by_value,
           :process, Process.by_value,
           :stream, Stream.by_value,
           :tcp, Tcp.by_value,
           :timer, Timer.by_value,
           :tty, Tty.by_value,
           :udp, Udp.by_value,
           :signal, Signal.by_value
  end

end
