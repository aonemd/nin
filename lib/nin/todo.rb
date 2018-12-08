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

    def add(desc)
      @items << Item.new(next_id, desc)
      @store.write(to_hash)
    end

    def update(id, new_desc)
      item      = find_by_id(id)
      item.desc = new_desc
    end

    def delete(id)
      item = find_by_id(id)
      @items.delete(item)
    end

    private

    def load_items
      @store.read.map do |key, value|
        Item.new(key, value.fetch('desc'))
      end
    end

    def to_hash
      @items.reduce({}) do |hash, item|
        hash[item.id] = { 'desc' => item.desc }
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
