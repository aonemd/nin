require 'test_helper'

module Nin
  module Integration
    class TodoistTest < Minitest::Test
      def setup
        @todoist = Todoist.new('myFakeToken')
      end

      def test_items
        assert_instance_of Array, @todoist.items
      end
    end
  end
end
