require_relative '../lib/nin.rb'

require 'minitest/autorun'

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

  class StoreTest < Minitest::Test
    def setup
      @file  = File.expand_path('./test/todos.toml')
      @store = Store.new(@file)
    end

    def teardown
      File.delete(@file)
    end

    def test_initialize_creates_new_store
      assert File.exists?(@file)
    end

    def test_read
      assert_kind_of Hash, @store.read
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
