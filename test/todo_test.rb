require 'test_helper'

module Nin
  class FakeStore
    def read
      {
        Date.today.to_s => [
          { 'id' => 1, 'desc' => 'Fake Task 1 desc', 'tags' => ['school'], 'completed' => true },
          { 'id' => 2, 'desc' => 'Fake Task 2 desc', 'tags' => [], 'completed' => false }
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

    def test_list
      output   = capture_stdout { @todo.list }
      expected = @todo.items.map do |item|
        item.to_s << "\n"
      end.join

      assert_equal expected, output
    end

    def test_add
      return_msg = @todo.add('Fake Task 3 desc', nil, [])

      assert_equal 3, @todo.items.count
      assert_equal 3, @todo.items.last.id
      assert_equal 'Wrote to store successfully', return_msg
    end

    def test_add_first_item
      @todo.items = []

      return_msg = @todo.add('Fake Task 1', nil, ['school'])

      assert_equal 1, @todo.items.count
      assert_equal 1, @todo.items.first.id
      assert_equal 'Wrote to store successfully', return_msg
    end

    def test_update
      return_msg = @todo.update(2, 'Fake Task 2 desc updated', nil)

      assert_equal 'Fake Task 2 desc updated', @todo.items.last.desc
      assert_equal 'Wrote to store successfully', return_msg
    end

    def test_delete
      return_msg = @todo.delete(2)

      assert_equal 1, @todo.items.count
      assert_equal 'Wrote to store successfully', return_msg
    end

    def test_complete
      @todo.complete(2)

      assert @todo.items.last.completed
    end
  end
end
