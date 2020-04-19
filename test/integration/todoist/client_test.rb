require 'test_helper'

module Nin
  module Integration
    module Todoist
      class ClientTest < Minitest::Test
        def setup
          @client = Client.new('myFakeToken')
        end

        def test_all_tasks
          assert_instance_of Array, @client.all_tasks
        end
      end
    end
  end
end
