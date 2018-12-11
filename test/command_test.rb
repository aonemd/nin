require 'test_helper'

module Nin
  class CommandTest < Minitest::Test
    def setup
    end

    def test_print_usage_by_default
      @command = Nin::Command.new('anything')

      output = capture_stdout { @command.call }

      assert output.include?('USAGE')
    end
  end
end
