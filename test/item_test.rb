require 'test_helper'

module Nin
  class ItemTest < Minitest::Test
    def setup
      @item_today        = Item.new(1, 'Item 1', nil)
      @item_tomorrow     = Item.new(2, 'Item 2', Date.today.succ)
      @item_yesterday    = Item.new(3, 'Item 3', Date.today.prev_day)
      @item_generic_date = Item.new(4, 'Item 4', Date.today.succ.succ)
      @item_with_tags    = Item.new(5, 'Item 5', nil, ['school'])
      @archived_item     = Item.new(6, 'Item 6', nil, [], nil, true, true)
    end

    def test_set_date_if_nil
      assert_equal Date.today, @item_today.date
    end

    def test_edit_desc_only
      @item_today.edit('new desc')

      assert_equal 'new desc', @item_today.desc
    end

    def test_edit_date
      @item_tomorrow.edit('Item 2', Date.today.succ.succ)

      assert_equal Date.today.succ.succ, @item_tomorrow.date
    end

    def test_edit_with_nil_date
      before_date = @item_tomorrow.date

      @item_tomorrow.edit('Item 2', nil)

      assert_equal Date.today.succ, before_date
    end

    def test_edit_appends_tags
      @item_with_tags.edit('Item 5', nil, ['semester_1'])

      assert_equal ['school', 'semester_1'], @item_with_tags.tags
    end

    def test_toggle_completed
      @item_today.toggle_completed!

      assert @item_today.completed
    end

    def test_toggle_archived
      @archived_item.toggle_archived!

      refute @archived_item.archived
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
