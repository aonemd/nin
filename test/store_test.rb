require 'toml-rb'

require 'test_helper'

require 'nin/store'

module Nin
  class StoreTest < Minitest::Test
    def setup
      @file  = File.expand_path('./test/todos.toml')
      @store = Store.new(@file)
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
  end
end
