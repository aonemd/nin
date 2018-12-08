require 'toml-rb'

module Nin
  class Item
    attr_accessor :body

    def initialize(desc)
      @desc = desc
    end

    def to_s
      "#{@desc}"
    end
  end

  class Store
    DEFAULT_FILE = "#{ENV['HOME']}/.todos.toml"

    def initialize(file = DEFAULT_FILE)
      @file = file

      init_store
    end

    def read
      TomlRB.load_file(@file)
    end

    def write
    end

    private

    def init_store
      return if File.exists?(@file)

      File.open(@file, "w")
    end
  end

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
      @store.read.values.map do |item|
        Item.new(item.fetch('desc'))
      end
    end
  end
end

if __FILE__ == $0
  case ARGV[0]
  when 'l'
    Nin::Todo.new.list
  when 'a'
    Nin::Todo.new.add(ARGV[1])
  when 'e'
    Nin::Todo.new.edit(ARGV[1])
  when 'd'
    Nin::Todo.new.delete(ARGV[1])
  else
    puts "\nUSAGE: nin COMMAND [arguments...]\n\n"
    puts "COMMANDS:"
    puts "  l             List all todos"
    puts "  a desc        Add a todo"
    puts "  e id          Edit a todo"
    puts "  d id          Remove a todo"
  end
end
