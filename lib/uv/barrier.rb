module UV
  # (Not documented)
  #
  # ## Fields:
  # :n ::
  #   (Integer)
  # :count ::
  #   (Integer)
  # :mutex ::
  #   (unknown)
  # :turnstile1 ::
  #   (Integer)
  # :turnstile2 ::
  #   (Integer)
  module BarrierWrappers
    # @param [Integer] count
    # @return [Integer]
    def init(count)
      UV.barrier_init(self, count)
    end

    # @return [nil]
    def destroy()
      UV.barrier_destroy(self)
    end

    # @return [nil]
    def wait()
      UV.barrier_wait(self)
    end
  end

  class Barrier < FFI::Struct
    include BarrierWrappers
    layout :n, :uint,
           :count, :uint,
           :mutex, :mutex,
           :turnstile1, :uint,
           :turnstile2, :uint
  end

end
