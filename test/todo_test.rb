require 'test_helper'

require 'nin/item'
require 'nin/todo'

module Nin
  class FakeStore
    def read
      {
        1 => { 'desc' => 'Fake Task 1 desc' },
        2 => { 'desc' => 'Fake Task 2 desc' }
      }
    end

    def write
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
  end
end
