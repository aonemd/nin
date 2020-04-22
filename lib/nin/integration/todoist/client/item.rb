module Nin
  module Integration
    class Todoist
      class Client
        class Item < BaseClient
          API_URI = "#{BASE_URI}/items".freeze

          def get(id)
            res = HTTP.headers(accept: "application/json")
              .get("#{API_URI}/get", params: { token: @token, item_id: id })

            JSON.parse(res.body.to_s).fetch('item')
          end
        end
      end
    end
  end
end
