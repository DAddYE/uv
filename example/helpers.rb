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

def resume(&block)
  fiber = Fiber.current
  ->(*args) do
    begin
      block[args] if block
    ensure
      fiber.resume(*args)
    end
  end
end
