module Nin
  module Integration
    class Todoist
      def initialize(token)
        @client = Client.new(token)
      end

      def items
        data = @client.sync.read_resources(['projects', 'items'])

        projects = data.fetch('projects').reduce({}) do |projects, p|
          projects.update(p["id"] => p["name"])
        end

        data.fetch('items').reduce([]) do |tasks, t|
          tasks << [
            t["content"],
            (t["due"] || {}).fetch('date', nil),
            projects.fetch(t["project_id"]),
            t["id"],
            (t["checked"] == "1")
          ]
        end
      end

      def find_item(id)
        @client.items.get(id)
      end
    end
  end
end
