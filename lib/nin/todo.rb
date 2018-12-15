module Nin
  class Todo
    attr_accessor :items
    attr_reader :store

    def initialize(store = TomlStore.new, options = {})
      @store   = store
      @options = options
      @items   = load_items.sort_by(&:date)
    end

    def list
      if @options[:archived]
        @items
      else
        unarchived_items
      end.each do |item|
        puts item
      end
    end

    def add(desc, date, tags)
      @items << Item.new(next_id, desc, date, tags)
      @store.write(to_hash)
    end

    def edit(id, desc, date, tags)
      item      = find_by_id(id)
      item.desc = desc
      item.date = date
      item.tags = tags
      @store.write(to_hash)
    end

    def complete(*ids)
      ids.each do |id|
        item = find_by_id(id.to_i)
        item.toggle_completed!
        @store.write(to_hash)
      end
    end

    def archive(*ids)
      ids.each do |id|
        item = find_by_id(id.to_i)
        item.toggle_archived!
        @store.write(to_hash)
      end
    end

    def delete(*ids)
      ids.each do |id|
        item = find_by_id(id.to_i)
        @items.delete(item)
        @store.write(to_hash)
      end
    end

    private

    def load_items
      items = []
      @store.read.map do |key, values|
        date = key.dup
        values.map do |item|
          items << Item.new(item.fetch('id').to_i,
                            item.fetch('desc'),
                            date,
                            item.fetch('tags'),
                            item.fetch('completed'),
                            item.fetch('archived')
                           )
        end
      end

      items
    end

    def to_hash
      @items.group_by(&:date).reduce({}) do |hash, (key, values)|
        hash[key] = values.map(&:to_h)
        hash
      end
    end

    def next_id
      last_id + 1
    end

    def last_id
      begin
        @items.sort_by(&:id).last.id
      rescue NoMethodError
        0
      end
    end

    def find_by_id(id)
      found_item = @items.find { |item| item.id == id }

      raise ItemNotFoundError unless found_item

      found_item
    end

    def unarchived_items
      @items.select { |item| !item.archived }
    end
  end
end
