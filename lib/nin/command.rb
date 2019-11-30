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
      when 'l', 'list'
        @todo.list
      when 'a', 'add'
        desc, date, tags = Parser.new(@args.join(' ')).call
        @todo.add(desc, date, tags)
      when 'e', 'edit'
        desc, date, tags = Parser.new(@args[1..-1].join(' ')).call
        @todo.edit(@args[0].to_i, desc, date, tags)
      when 'p', 'prioritize'
        @todo.prioritize(@args[0].to_i, @args[1].to_i)
      when 'c', 'complete'
        @todo.complete(*@args)
      when 'ac', 'archive'
        @todo.archive(*@args)
      when 'd', 'delete'
        @todo.delete(*@args)
      when 'gc', 'garbage'
        @todo.delete_archived
      when 's', 'analyze'
        @todo.analyze
      when 'i', 'repl'
        run_interactive_mode
      when 'o', 'open'
        system("`echo $EDITOR` #{@todo.store.file}")
      else
        puts "NAME:\n\tnin - a simple, full-featured command line todo app"
        puts "\nUSAGE:\n\tnin COMMAND [arguments...]"
        puts "\nCOMMANDS:"
        puts "\tl  | list          [a]        List all unarchived todos. Pass optional argument `a` to list all todos"
        puts "\ta  | add           desc       Add a todo. Prepend due date by a @. Prepend each tag by a \\#"
        puts "\te  | edit          id desc    Edit a todo. Prepend due date by a @. Prepend each tag by a \\#"
        puts "\tp  | prioritize    id step    Prioritize a todo by either a positive or negative step within its date group"
        puts "\tc  | complete      id(s)      Un/complete todo(s)"
        puts "\tac | archive       id(s)      Un/archive todo(s)"
        puts "\td  | delete        id(s)      Delete todo(s)"
        puts "\tgc | garbage                  Delete all archived todos. Resets item ids as a side effect"
        puts "\ts  | analyze                  Analyze tasks and print statistics"
        puts "\ti  | repl                     Open nin in REPL mode"
        puts "\to  | open                     Open todo file in $EDITOR"
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
