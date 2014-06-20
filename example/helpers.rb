require 'fiber'

# Helpers
def refute_error(error_code)
  return if error_code.nil?
  return if error_code >= 0
  name = UV.err_name(error_code) || error_code
  msg  = UV.strerror(error_code)
  raise RuntimeError, "#{msg} - #{name}", caller
end

def assert_kind_of(type, actual)
  return if actual.kind_of?(type)
  msg = "value #{actual.inspect} is not a valid #{type}"
  raise ArgumentError, msg, caller
end

def wait
  Fiber.yield
end

def __fiber__
  @___fiber__
end

def async(method_name)
  unbound_method = method(method_name).clone
  define_method(method_name) do |*args, &block|
    begin
      @___fiber__, was = Fiber.current, __fiber__
      unbound_method[*args, &block]
      Fiber.yield
    rescue Exception => e
      # If callbacks are run from a separate C thread, any exceptions raised will not be propagated
      # to Ruby. Therefore, it may seem the callbacks are just not doing anything. In such cases,
      # it is helpful to add an exception handler inside the callback, even just to print the
      # exception. Note that this is is a special case, and exceptions will mostly be propagated up
      # to the Ruby method triggering the callback.
      # Rif.: https://github.com/mvz/ruby-gir-ffi/wiki/Exceptions-in-callbacks
      warn(e, e.backtrace)
    ensure
      @___fiber__ = was
    end
  end
end

def resume(&block)
  raise 'Nothing to resume, you need to be in a Fiber.yield' unless __fiber__
  f = __fiber__ # lock a reference here
  ->(*args) do
    begin
      args = block[args] if block
    rescue Exception => e
      # If callbacks are run from a separate C thread, any exceptions raised will not be propagated
      # to Ruby. Therefore, it may seem the callbacks are just not doing anything. In such cases,
      # it is helpful to add an exception handler inside the callback, even just to print the
      # exception. Note that this is is a special case, and exceptions will mostly be propagated up
      # to the Ruby method triggering the callback.
      # Rif.: https://github.com/mvz/ruby-gir-ffi/wiki/Exceptions-in-callbacks
      warn(e, e.backtrace)
    ensure
      f.resume(*args) if f && f.alive?
    end
  end
end

def sync(*args, &block)
  Fiber.new(*args, &block).resume
end

def uv_trap(loop, signame, &block)
  signal = UV::Signal.new
  err = UV.signal_init(loop, signal)
  refute_error(err)
  err = UV.signal_start(signal, block, Signal.list[signame.to_s])
  UV.unref(UV::Handle.new(signal.to_ptr))
  refute_error(err)
end
