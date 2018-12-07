require File.join(File.dirname(__FILE__), 'nin.rb')

require 'minitest/autorun'

module NinTest
  class Item < Minitest::Test
    def test_it_deos_something_useful
      assert 1 == 1
    end
  end

  class Todo < Minitest::Test
  end
end
