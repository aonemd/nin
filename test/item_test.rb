require 'test_helper'

module Nin
  class ItemTest < Minitest::Test
    def setup
      @item1 = Item.new(1, 'Item 1')
    end

    def test_toggle_completed
      @item1.toggle_completed!

      assert @item1.completed
    end

    def test_to_s
      assert_equal "[ ] 1: Item 1", @item1.to_s
    end
  end
end
