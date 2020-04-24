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

          projects      = @service.projects.all
          project_names = projects.values
          project_name = item.tags.first

          uid = if project_name
                  project_id = unless project_names.include?(project_name)
                                 @service.projects.add(name: project_name)
                               else
                                 projects.find { |k, v| v == project_name }.first
                               end

                  @service.items.add(content: item.desc, due: { date: item.date }, project_id: project_id)
                else
                  @service.items.add(content: item.desc, due: { date: item.date })
                end

          item.uid = uid
        end

        def sync_edit(params)
          item = params.fetch(:item)

          projects      = @service.projects.all
          project_names = projects.values

          if project_name = item.tags.first
            project_id = unless project_names.include?(project_name)
                           @service.projects.add(name: project_name)
                         else
                           projects.find { |k, v| v == project_name }.first
                         end

            @service.items.update(id: item.uid, content: item.desc, due: { date: item.date }, checked: item.completed, project_id: project_id)
          else
            @service.items.update(id: item.uid, content: item.desc, due: { date: item.date }, checked: item.completed)
          end
        end

        def sync_delete(params)
          @service.items.delete(params.fetch(:ids))
        end
      end
    end
  end
end
