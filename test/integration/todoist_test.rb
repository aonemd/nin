require 'test_helper'

module Nin
  module Integration
    class TodoistTest < Minitest::Test
      def setup
        @todoist = Todoist.new('myFakeToken')
      end

      def test_fetch
        assert_instance_of Array, @todoist.fetch
      end
    end
  end
end
