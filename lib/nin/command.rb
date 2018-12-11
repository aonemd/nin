module Nin
  class Command
    def initialize(command, args = [])
      @command = command
      @args    = args

      @todo    = Todo.new
    end

    def call
      case @command
      when 'l'
        @todo.list
      when 'a'
        desc, date, tags = Parser.new(@args.join(' ')).call
        @todo.add(desc, date, tags)
      when 'e'
        desc, date, tags = Parser.new(@args[1..-1].join(' ')).call
        @todo.edit(@args[0].to_i, desc, date, tags)
      when 'c'
        @todo.complete(@args[0].to_i)
      when 'd'
        @todo.delete(@args[0].to_i)
      else
        puts "\nUSAGE: nin COMMAND [arguments...]\n\n"
        puts "COMMANDS:"
        puts "  l             List all todos"
        puts "  a desc        Add a todo"
        puts "  u id desc     Update a todo"
        puts "  c id          Un/complete a todo"
        puts "  d id          Remove a todo"
      end
    end
  end
end
