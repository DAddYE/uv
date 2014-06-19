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
    ensure
      @__fiber__ = was
    end
  end
end

def resume(&block)
  ->(*args) do
    begin
      block[args] if block
    ensure
      __fiber__.resume(*args)
    end
  end
end

def sync(*args, &block)
  Fiber.new(*args, &block).resume
end
