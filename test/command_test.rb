require 'test_helper'

module Nin
  class CommandTest < Minitest::Test
    def setup
    end

    def test_print_usage_by_default
      @command = Nin::Command.new('anything', [])

      output = capture_stdout { @command.call }

      assert output.include?('USAGE')
    end

    def test_add_empty_item
      assert_raises("Command arguments cannot be empty!") do
        @command = Nin::Command.new('a', [])
      end
    end

    def test_edit_empty_item
      assert_raises("Command arguments cannot be empty!") do
        @command = Nin::Command.new('e', [])
      end
    end
  end
end
