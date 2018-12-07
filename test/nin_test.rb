require_relative '../lib/nin.rb'

require 'minitest/autorun'

class Nin::TodoTest < Minitest::Test
  def setup
    @todo = Nin::Todo.new(store: File.expand_path('./test/todos.toml'))
  end

  def test_initialize_loads_items
    refute_empty @todo.items
  end
end
