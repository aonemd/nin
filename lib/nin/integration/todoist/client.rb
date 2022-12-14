module Nin
  module Integration
    module Todoist
      class Client
        BASE_URI = 'https://api.todoist.com/sync/v9'.freeze

        def initialize(token)
          @token = token
        end

        def sync
          @sync ||= Client::Sync.new(@token)
        end

        def projects
          @projects ||= Client::Project.new(@token)
        end

        def items
          @items ||= Client::Item.new(@token)
        end
      end
    end
  end
end
