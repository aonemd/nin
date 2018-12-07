require_relative '../lib/nin.rb'

require 'minitest/autorun'

class Nin::TodoTest < Minitest::Test
  def setup
    @store = File.expand_path('./test/todos.toml')
    @todo  = Nin::Todo.new(store: @store)
  end

  def test_initialize_creates_new_store
    assert File.exists?(@store)
  end

  def test_initialize_loads_items
    refute_empty @todo.items
  end
end
