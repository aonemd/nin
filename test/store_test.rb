require 'test_helper'

module Nin
  class StoreTest < Minitest::Test
    def setup
      @file  = File.expand_path('./test/todos.toml')
      @store = Store.new(@file)
      @hash  = {
        1 => { 'desc' => 'Task 1 desc' },
        2 => { 'desc' => 'Task 2 desc' }
      }
    end

    def teardown
      File.delete(@file)
    end

    def test_initialize_creates_new_store
      assert File.exist?(@file)
    end

    def test_read
      assert_kind_of Hash, @store.read
    end

    def test_write
      @store.write(@hash)

      refute File.zero?(@file)
    end
  end
end
