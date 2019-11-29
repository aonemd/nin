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
      when 'p'
        @todo.prioritize(@args[0].to_i, @args[1].to_i)
      when 'c'
        @todo.complete(*@args)
      when 'ac'
        @todo.archive(*@args)
      when 'd'
        @todo.delete(*@args)
      when 'gc'
        @todo.delete_archived
      when 'o'
        system("`echo $EDITOR` #{@todo.store.file}")
      when 'i'
        run_interactive_mode
      else
        puts "NAME:\n\tnin - a simple, full-featured command line todo app"
        puts "\nUSAGE:\n\tnin COMMAND [arguments...]"
        puts "\nCOMMANDS:"
        puts "\tl  [a]         List all unarchived todos. Pass optional argument `a` to list all todos"
        puts "\ta  desc        Add a todo. Prepend due date by a @. Prepend each tag by a \\#"
        puts "\te  id desc     Edit a todo. Prepend due date by a @. Prepend each tag by a \\#"
        puts "\tp  id step     Prioritize a todo by either a positive or negative step within its date group"
        puts "\tc  id(s)       Un/complete todo(s)"
        puts "\tac id(s)       Un/archive todo(s)"
        puts "\td  id(s)       Delete todo(s)"
        puts "\tgc             Delete all archived todos. Resets item ids as a side effect"
        puts "\to              Open todo file in $EDITOR"
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

    def run_interactive_mode
      while line = Readline.readline("nin> ", true)
        line = line.split(' ')

        Command.new(line[0], line[1..-1]).call
      end
    end
  end
end
