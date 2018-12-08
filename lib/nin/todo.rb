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

    def add(todo)
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
  end
end
