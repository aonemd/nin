module Nin
  module Integration
    class Todoist
      class Client
        API_URI = 'https://api.todoist.com/sync/v8/sync'.freeze

        def initialize(token)
          @token = token
        end

        def all_projects_and_items
          res = HTTP.headers(accept: "application/json")
            .get("#{API_URI}/", params: { token: @token,
                                          sync_token: '*',
                                          resource_types: ['projects', 'items'].to_json })

          JSON.parse(res.body.to_s).slice('projects', 'items')
        end
      end
    end
  end
end
