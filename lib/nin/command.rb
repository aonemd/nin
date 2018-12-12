module Nin
  class Command
    def initialize(command, args)
      @command = command
      @args    = args
      @todo    = Todo.new(Store.new, collect_options)

      validate_args_for_add_and_edit
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
      when 'ac'
        @todo.archive(@args[0].to_i)
      when 'd'
        @todo.delete(@args[0].to_i)
      else
        puts "\nUSAGE: nin COMMAND [arguments...]\n\n"
        puts "COMMANDS:"
        puts "  l  [a]         List all unarchived todos. Pass optional argument `a` to list all todos"
        puts "  a  desc        Add a todo"
        puts "  e  id desc     Edit a todo"
        puts "  c  id          Un/complete a todo"
        puts "  ac id          Un/archive a todo"
        puts "  d  id          Remove a todo"
      end
    end

    private

    def collect_options
      options = { archived: false }

      if @command == 'l' && @args[0] == 'a'
        options[:archived] = true
      end

      options
    end

    def validate_args_for_add_and_edit
      if (@command == 'a' || @command == 'e') && @args.empty?
        raise "Command arguments cannot be empty!"
      end
    end
  end
end
