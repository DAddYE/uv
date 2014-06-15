module UV
  # (Not documented)
  #
  # ## Fields:
  # :rbe_left ::
  #   (Timer)
  # :rbe_right ::
  #   (Timer)
  # :rbe_parent ::
  #   (Timer)
  # :rbe_color ::
  #   (Integer)
  class TimerTreeEntry < FFI::Struct
    layout :rbe_left, Timer.by_ref,
           :rbe_right, Timer.by_ref,
           :rbe_parent, Timer.by_ref,
           :rbe_color, :int
  end

end
