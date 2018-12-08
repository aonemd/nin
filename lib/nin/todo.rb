module Nin
  class Todo
    attr_accessor :items
    attr_reader :store

    def initialize(store = Store.new)
      @store = store
      @items = load_items
    end

    def list
    end

    def add(desc)
      @items << Item.new(next_id, desc)
      @store.write(to_hash)
    end

    def edit(id)
    end

    def delete(id)
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
  end
end
