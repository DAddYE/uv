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
    layout :rbe_left, :pointer,
           :rbe_right, :pointer,
           :rbe_parent, :pointer,
           :rbe_color, :int
  end

end
