module Nin
  module Integration
    class Todoist
      def initialize(token)
        @client = Client.new(token)
      end

      def fetch
        _projects = extract_projects
        extract_tasks(_projects)
      end

      private

      def extract_projects
        @client.all_projects.reduce({}) do |projects, p|
          projects.update(p["id"] => p["name"])
        end
      end

      def extract_tasks(projects)
        @client.all_tasks.reduce([]) do |tasks, t|
          tasks << [
            t["content"],
            t["created"],
            projects.fetch(t["project_id"]),
            t["id"],
            t["completed"]
          ]
        end
      end
    end
  end
end
