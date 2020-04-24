module Nin
  module Integration
    class Synchronizer
      class Todoist < Synchronizer
        def sync(op, params = {})
          case op
          when :read
            sync_read(params)
          when :add
            sync_add(params)
          when :edit
            sync_edit(params)
          end
        end

        private

        def sync_read(params)
          items   = params.fetch(:items)
          next_id = params.fetch(:next_id)

          id = next_id
          synced_uids = fetch_items.map do |t|
            item          = Item.new(id, *t)
            existing_item = items.find_by(:uid, item.uid)

            if existing_item
              existing_item.edit(item.desc, item.date, item.tags, item.completed)
            else
              items << item

              id += 1
            end

            item.uid
          end

          unsynced_uids = items.where(:uid) { |item_uid| !item_uid.nil? }.map(&:uid) - synced_uids
          unsynced_uids.each do |uid|
            item = items.find_by(:uid, uid)
            t = @client.items.get(uid)

            items.delete(item) and next if t.nil? || t.fetch("is_deleted") == 1

            if t.fetch("checked") == 1
              item.completed = true
            else
              item.completed = false
            end
          end
        end

        def sync_add(params)
          item = params.fetch(:item)

          projects      = fetch_projects
          project_names = projects.values
          project_name = item.tags.first

          uid = if project_name
                  project_id = unless project_names.include?(project_name)
                                 add_project(name: project_name)
                               else
                                 projects.find { |k, v| v == project_name }.first
                               end

                  add_item(content: item.desc, due: { date: item.date }, project_id: project_id)
                else
                  add_item(content: item.desc, due: { date: item.date })
                end

          item.uid = uid
        end

        def sync_edit(params)
          item = params.fetch(:item)

          projects      = fetch_projects
          project_names = projects.values

          if project_name = item.tags.first
            project_id = unless project_names.include?(project_name)
                           add_project(name: project_name)
                         else
                           projects.find { |k, v| v == project_name }.first
                         end

            update_item(id: item.uid, content: item.desc, due: { date: item.date }, checked: item.completed, project_id: project_id)
          else
            update_item(id: item.uid, content: item.desc, due: { date: item.date }, checked: item.completed)
          end
        end

        def fetch_projects
          @client
            .sync
            .read_resources(['projects'])
            .fetch('projects').reduce({}) { |projects, p| projects.update(p["id"] => p["name"]) }
        end

        def fetch_items
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

        def update_item(item)
          commands = [
            {
              "type": "item_update",
              "uuid": SecureRandom.uuid,
              "args": item
            }
          ].to_json

          @client.sync.write_resources(commands)
        end
      end
    end
  end
end
