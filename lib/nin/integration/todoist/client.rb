module Nin
  module Integration
    module Todoist
      class Client
        API_URI = 'https://api.todoist.com/rest/v1'.freeze

        def initialize(token)
          @token = token
        end

        def all_tasks
          res = HTTP.headers(accept: "application/json")
            .auth("Bearer #{@token}")
            .get("#{API_URI}/tasks")

          JSON.parse(res.body.to_s)
        end
      end
    end
  end
end
