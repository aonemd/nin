require 'toml-rb'

require_relative 'nin/store'
require_relative 'nin/item'
require_relative 'nin/todo'

module Nin
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
