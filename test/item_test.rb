require 'test_helper'

module Nin
  class ItemTest < Minitest::Test
    def setup
      @item_today        = Item.new(1, 'Item 1', nil)
      @item_tomorrow     = Item.new(2, 'Item 2', Date.today.succ.to_s)
      @item_yesterday    = Item.new(3, 'Item 3', Date.today.prev_day.to_s)
      @item_generic_date = Item.new(4, 'Item 4', Date.today.succ.succ.to_s)
      @item_with_tags    = Item.new(5, 'Item 5', nil, ['school'])
    end

    def test_set_date_if_nil
      assert_equal Date.today.to_s, @item_today.date
    end

    def test_update_date_if_nil
      @item_today.date = nil

      assert_equal Date.today.to_s, @item_today.date
    end

    def test_toggle_completed
      @item_today.toggle_completed!

      assert @item_today.completed
    end

    def test_to_s
      assert_equal "[ ] 1: @today Item 1", @item_today.to_s
    end

    def test_to_s_with_tomorrow_date
      assert_equal "[ ] 2: @tomorrow Item 2", @item_tomorrow.to_s
    end

    def test_to_s_with_yasterday_date
      assert_equal "[ ] 3: @yesterday Item 3", @item_yesterday.to_s
    end

    def test_to_s_with_generic_date
      assert_equal "[ ] 4: @#{Date.today.succ.succ.to_s} Item 4", @item_generic_date.to_s
    end

    def test_to_s_with_tags
      assert_equal "[ ] 5: @today #school Item 5", @item_with_tags.to_s
    end
  end
end
