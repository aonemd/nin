require 'test_helper'

module Nin
  class FakeStore
    def read
      {
        Date.today.to_s => [
          { 'id' => 1, 'desc' => 'Fake Task 1 desc', 'tags' => ['school'], 'completed' => true },
          { 'id' => 2, 'desc' => 'Fake Task 2 desc', 'tags' => [], 'completed' => false }
        ],
        Date.today.prev_day.to_s => [
          { 'id' => 3, 'desc' => 'Fake Task 3 desc', 'tags' => ['fake_tag'], 'completed' => true }
        ]
      }
    end

    def write(hash)
      'Wrote to store successfully'
    end
  end

  class TodoTest < Minitest::Test
    def setup
      @store = FakeStore.new()
      @todo  = Nin::Todo.new(@store)
    end

    def test_initialize_loads_items
      refute_empty @todo.items
    end

    def test_initialize_orders_items_by_date
      assert ascending?(@todo.items, :date)
    end

    def test_list
      expected = @todo.items.map do |item|
        item.to_s << "\n"
      end.join

      assert_output(expected) { @todo.list }
    end

    def test_add
      old_item_count = @todo.items.count
      last_id        = @todo.items.last.id
      return_msg     = @todo.add('Fake Task 3 desc', nil, [])

      assert_equal 1, @todo.items.count - old_item_count
      assert_equal 1, @todo.items.last.id - last_id
      assert_equal 'Wrote to store successfully', return_msg
    end

    def test_add_first_item
      @todo.items = []

      return_msg = @todo.add('Fake Task 1', nil, ['school'])

      assert_equal 1, @todo.items.count
      assert_equal 1, @todo.items.first.id
      assert_equal 'Wrote to store successfully', return_msg
    end

    def test_edit
      return_msg = @todo.edit(2, 'Fake Task 2 desc editd', nil, [])

      assert_equal 'Fake Task 2 desc editd', @todo.items.last.desc
      assert_equal 'Wrote to store successfully', return_msg
    end

    def test_delete
      old_item_count = @todo.items.count
      return_msg     = @todo.delete(2)

      assert_equal 1, old_item_count - @todo.items.count
      assert_equal 'Wrote to store successfully', return_msg
    end

    def test_complete
      @todo.complete(2)

      assert @todo.items[1].completed
    end
  end
end
