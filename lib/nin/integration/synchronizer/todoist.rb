module Nin
  module Integration
    class Synchronizer
      class Todoist < Synchronizer
        def sync(op, params = {})
          @service = Integration::Service::Todoist.new(@client)

          case op
          when :read
            sync_read(params)
          when :add
            sync_add(params)
          when :edit
            sync_edit(params)
          when :delete
            sync_delete(params)
          end
        end

        private

        def sync_read(params)
          items   = params.fetch(:items)
          next_id = params.fetch(:next_id)

          id = next_id
          synced_uids = @service.items.all.map do |t|
            item = Item.new(id, *t)

            if existing_item = items.find_by(:uid, item.uid)
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
            t    = @client.items.get(uid)

            items.delete(item) and next if t.nil? || t.fetch("is_deleted") == 1
            item.completed = (t.fetch("checked") == 1)
          end
        end

        def sync_add(params)
          item = params.fetch(:item)

          payload = _get_item_write_payload(item)

          uid = @service.items.add(payload)
          item.uid = uid
        end

        def sync_edit(params)
          item = params.fetch(:item)

          payload      = _get_item_write_payload(item)
          payload[:id] = item.uid

          @service.items.update(payload)
        end

        def sync_delete(params)
          @service.items.delete(params.fetch(:ids))
        end

        def _get_item_write_payload(item)
          payload = {
            content: item.desc,
            due: { date: item.date },
            checked: item.completed
          }

          if project_name = item.tags.first
            projects      = @service.projects.all
            project_names = projects.values

            project_id = unless project_names.include?(project_name)
                           @service.projects.add(name: project_name)
                         else
                           projects.find { |k, v| v == project_name }.first
                         end

            payload[:project_id] = project_id
          end

          payload
        end
      end
    end
  end
end
