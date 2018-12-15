module Nin
  class Command
    COMMANDS_WITH_ARGS = %w(a e c ac d)

    def initialize(command, args)
      @command = command
      @args    = args
      @todo    = Todo.new(YamlStore.new, collect_options)

      validate_args
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
        @todo.complete(*@args)
      when 'ac'
        @todo.archive(*@args)
      when 'd'
        @todo.delete(*@args)
      else
        puts "\nUSAGE: nin COMMAND [arguments...]\n\n"
        puts "COMMANDS:"
        puts "  l  [a]         List all unarchived todos. Pass optional argument `a` to list all todos"
        puts "  a  desc        Add a todo"
        puts "  e  id desc     Edit a todo"
        puts "  c  ids         Un/complete a todo"
        puts "  ac ids         Un/archive a todo"
        puts "  d  ids         Remove a todo"
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

    def validate_args
      COMMANDS_WITH_ARGS.each do |command|
        raise EmptyCommandArgumentError if @command == command && @args.empty?
      end
    end
  end
end
