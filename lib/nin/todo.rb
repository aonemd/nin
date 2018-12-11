module Nin
  class Todo
    attr_accessor :items
    attr_reader :store

    def initialize(store = Store.new)
      @store = store
      @items = load_items
    end

    def list
      @items.each do |item|
        puts item
      end
    end

    def add(desc, date, tags)
      @items << Item.new(next_id, desc, date, tags)
      @store.write(to_hash)
    end

    def update(id, desc, date)
      item      = find_by_id(id)
      item.desc = desc
      item.date = date
      @store.write(to_hash)
    end

    def complete(id)
      item = find_by_id(id)
      item.toggle_completed!
      @store.write(to_hash)
    end

    def delete(id)
      item = find_by_id(id)
      @items.delete(item)
      @store.write(to_hash)
    end

    private

    def load_items
      items = []
      @store.read.map do |key, values|
        date = key
        values.map do |item|
          items << Item.new(item.fetch('id').to_i,
                            item.fetch('desc'),
                            date,
                            item.fetch('tags'),
                            item.fetch('completed')
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
      begin
        @items.last.id + 1
      rescue NoMethodError
        1
      end
    end

    def find_by_id(id)
      @items.find { |item| item.id == id }
    end
  end
end
