require "bundler/setup"
Bundler.require(:default)
require "minitest/autorun"
require "minitest/pride"

class Minitest::Test
  def setup
    # autoload before GC.stress
    ThunderSVM::FFI if stress?

    GC.stress = true if stress?
  end

  def teardown
    GC.stress = false if stress?
  end

  def stress?
    ENV["STRESS"]
  end

  def assert_elements_in_delta(expected, actual, delta = 0.001)
    assert_equal expected.size, actual.size
    expected.to_a.zip(actual.to_a) do |exp, act|
      assert_in_delta exp, act, delta
    end
  end
end
