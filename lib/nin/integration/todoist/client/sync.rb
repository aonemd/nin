module Nin
  module Integration
    module Todoist
      class Client
        class Sync < BaseClient
          API_URI = "#{BASE_URI}/sync".freeze

          def read_resources(resource_types = ['all'], sync_token = '*')
            res = HTTP.headers(accept: "application/json")
              .get("#{BASE_URI}/sync", params: { token: @token,
                                                 sync_token: sync_token,
                                                 resource_types: resource_types.to_json })

            data = JSON.parse(res.body.to_s)
            unless resource_types == ['all']
              data.slice(*resource_types)
            else
              data
            end
          end

          def write_resources(commands)
            res = HTTP.headers(accept: "application/json")
              .get("#{BASE_URI}/sync", params: { token: @token,
                                                 commands: commands })

            JSON.parse(res.body.to_s)
          end
        end
      end
    end
  end
end
