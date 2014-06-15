module UV
  # (Not documented)
  #
  # ## Fields:
  # :rbe_left ::
  #   (Signal)
  # :rbe_right ::
  #   (Signal)
  # :rbe_parent ::
  #   (Signal)
  # :rbe_color ::
  #   (Integer)
  class SignalTreeEntry < FFI::Struct
    layout :rbe_left, Signal.by_ref,
           :rbe_right, Signal.by_ref,
           :rbe_parent, Signal.by_ref,
           :rbe_color, :int
  end

end
