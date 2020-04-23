module Nin
  module Integration
    class Todoist
      class Client
        class Project < BaseClient
          API_URI = "#{BASE_URI}/projects".freeze

          def get(id)
            res = HTTP.headers(accept: "application/json")
              .get("#{API_URI}/get", params: { token: @token, project_id: id })

            JSON.parse(res.body.to_s)['project']
          end
          #
          # def add(project)
          #   res = HTTP.headers(accept: "application/json")
          #     .get("#{API_URI}/add", params: { token: @token, **project })
          #
          #   JSON.parse(res.body.to_s)
          # end
        end
      end
    end
  end
end
