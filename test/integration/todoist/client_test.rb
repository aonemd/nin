require 'test_helper'

module Nin
  module Integration
    class Todoist
      class ClientTest < Minitest::Test
        def setup
          @client = Client.new('myFakeToken')
        end

        def test_all_projects_and_items
          assert_instance_of Hash, @client.all_projects_and_items
        end
      end
    end
  end
end
