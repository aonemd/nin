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
      assert @item_today.to_s.include?('[ ]')
      assert @item_today.to_s.include?('1')
      assert @item_today.to_s.include?('@today')
      assert @item_today.to_s.include?('Item 1')
    end

    def test_to_s_with_tomorrow_date
      assert @item_tomorrow.to_s.include?('@tomorrow')
    end

    def test_to_s_with_yasterday_date
      assert @item_yesterday.to_s.include?('@yesterday')
    end

    def test_to_s_with_generic_date
      assert @item_generic_date.to_s.include?(Date.today.succ.succ.to_s)
      assert @item_generic_date.to_s.include?('@')
    end

    def test_to_s_with_tags
      assert @item_with_tags.to_s.include?('#school')
    end
  end
end
