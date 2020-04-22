module Nin
  module Integration
    class Todoist
      class Client
        BASE_URI = 'https://api.todoist.com/sync/v8'.freeze

        def initialize(token)
          @token = token
        end

        def sync
          @sync ||= Client::Sync.new(@token)
        end

        def items
          @items ||= Client::Item.new(@token)
        end
      end
    end
  end
end
