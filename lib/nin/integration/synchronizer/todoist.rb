module Nin
  module Integration
    class Synchronizer
      class Todoist < Synchronizer
        def sync_up(params)
          items = params.fetch(:items)

          projects      = @client.projects
          project_names = projects.values
          unsynced_items = items.where(:uid) { |item_uid| item_uid.nil? }
          unsynced_items.each do |item|
            project_name = item.tags.first
            uid = if project_name
                    project_id   = unless project_names.include?(project_name)
                                     @client.add_project(name: project_name)
                                   else
                                     projects.find { |k, v| v == project_name }.first
                                   end

                    @client.add_item(content: item.desc, due: { date: item.date }, project_id: project_id)
                  else
                    @client.add_item(content: item.desc, due: { date: item.date })
                  end

            item.uid = uid
          end
        end

        def sync_down(params)
          items   = params.fetch(:items)
          next_id = params.fetch(:next_id)

          id = next_id
          synced_uids = @client.items.map do |t|
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
            t = @client.find_item(uid)

            items.delete(item) and next if t.nil? || t.fetch("is_deleted") == 1

            if t.fetch("checked") == 1
              item.completed = true
            else
              item.completed = false
            end
          end
        end
      end
    end
  end
end
