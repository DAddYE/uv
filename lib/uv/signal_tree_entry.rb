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
    layout :rbe_left, :pointer,
           :rbe_right, :pointer,
           :rbe_parent, :pointer,
           :rbe_color, :int
  end

end
