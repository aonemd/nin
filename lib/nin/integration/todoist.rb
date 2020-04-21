module Nin
  module Integration
    class Todoist
      def initialize(token)
        client              = Client.new(token)
        _projects_and_tasks = client.all_projects_and_items
        @projects           = _projects_and_tasks.fetch('projects')
        @items              = _projects_and_tasks.fetch('items')
      end

      def fetch
        _projects = extract_projects
        extract_tasks(_projects)
      end

      private

      def extract_projects
        @projects.reduce({}) do |projects, p|
          projects.update(p["id"] => p["name"])
        end
      end

      def extract_tasks(projects)
        @items.reduce([]) do |tasks, t|
          tasks << [
            t["content"],
            (t["due"] || {}).fetch('date', nil),
            projects.fetch(t["project_id"]),
            t["id"]
          ]
        end
      end
    end
  end
end
