module Nin
  module Integration
    class Service
      class Todoist < Service
        def projects
          @projects ||= Project.new(@client)
        end

        def items
          @items ||= Item.new(@client)
        end

        class Project < Service
          def all
            @client
              .sync
              .read_resources(['projects'])
              .fetch('projects').reduce({}) { |projects, p| projects.update(p["id"] => p["name"]) }
          end

          def add(project)
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
        end

        class Item < Service
          def all
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

          def add(item)
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

          def update(items)
            commands = items.ensure_array.map do |item|
              {
                "type": "item_update",
                "uuid": SecureRandom.uuid,
                "args": item
              }
            end.to_json

            @client.sync.write_resources(commands)
          end

          def delete(ids)
            commands = ids.ensure_array.map do |id|
              {
                "type": "item_delete",
                "uuid": SecureRandom.uuid,
                "args": { 'id': id }
              }
            end.to_json

            @client.sync.write_resources(commands)
          end
        end
      end
    end
  end
end
