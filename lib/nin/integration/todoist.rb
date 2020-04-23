module Nin
  module Integration
    class Todoist
      def initialize(token)
        @client = Client.new(token)
      end

      def projects
        data = @client.sync.read_resources(['projects'])

        data.fetch('projects').reduce({}) do |projects, p|
          projects.update(p["id"] => p["name"])
        end
      end

      def find_project(id)
        @client.projects.get(id)
      end

      def add_project(project)
        commands = [
          {
            "type": "project_add",
            "temp_id": SecureRandom.uuid,
            "uuid": SecureRandom.uuid,
            "args": project
          }
        ].to_json

        @client.sync.write_resources(commands).fetch('temp_id_mapping').values.first
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

      def add_item(item)
        commands = [
          {
            "type": "item_add",
            "temp_id": SecureRandom.uuid,
            "uuid": SecureRandom.uuid,
            "args": item
          }
        ].to_json

        @client.sync.write_resources(commands).fetch('temp_id_mapping').values.first
      end
    end
  end
end
