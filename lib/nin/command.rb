module Nin
  class Command
    COMMANDS_WITH_ARGS = %w(a e c ac d)

    def initialize(command, args, config = {})
      @command = command
      @args    = args
      @config  = config
      @todo    = Todo.new(collect_config, collect_options)

      validate_args
    end

    def call
      case @command
      when 'l', 'list'
        @todo.list
      when 'a', 'add'
        desc, date, tags = parse_item_desc(@args.join(' '))
        @todo.add(desc, date, tags)
      when 'e', 'edit'
        desc, date, tags = parse_item_desc(@args[1..-1].join(' '))
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
      when 'v', 'version'
        puts "nin #{Nin::VERSION}"
      else
        puts "NAME:\n\tnin - a simple, full-featured command line todo app"
        puts "\nUSAGE:\n\tnin COMMAND [arguments...]"
        puts "\nCOMMANDS:"
        puts "\tl  | list          [a|l]      List all unarchived todos. Pass optional argument `a` to list all todos or `l` to list local todos only"
        puts "\ta  | add           desc       Add a todo. Prepend due date by a @. Prepend each tag by a \\#"
        puts "\te  | edit          id desc    Edit a todo. Prepend due date by a @. Prepend each tag by a \\#"
        puts "\tp  | prioritize    id step    Prioritize a todo by either a positive or negative step within its date group"
        puts "\tc  | complete      id(s)      Un/complete todo(s)"
        puts "\tac | archive       id(s)|c    Un/archive todo(s) or pass `c` to archive all completed items"
        puts "\td  | delete        id(s)      Delete todo(s)"
        puts "\tgc | garbage                  Delete all archived todos. Resets item ids as a side effect"
        puts "\ts  | analyze                  Analyze tasks and print statistics"
        puts "\ti  | repl                     Open nin in REPL mode"
        puts "\to  | open                     Open todo file in $EDITOR"
        puts "\tv  | version                  Print current version of nin"
      end
    end

    private

    def collect_config
      config = { store: YamlStore.new }

      _client_name        = @config.fetch(:integration_client, nil)
      _client_credentials = @config.fetch(:integration_client_token, nil)
      _timeout_interval   = @config.fetch(:integration_timeout_interval, 60)
      if _client_name && _client_credentials
        _client_klass       = Object.const_get("Nin::Integration::#{_client_name.capitalize}::Client")
        _synchronizer_klass = Object.const_get("Nin::Integration::Synchronizer::#{_client_name.capitalize}")

        config[:integration_syncrhonizer] = _synchronizer_klass.new(_client_klass.new(_client_credentials), _timeout_interval)
      end

      config
    end

    def collect_options
      options = { archived: false, local: false, completed_only: false }

      if @command == 'l' && @args[0] == 'a'
        options[:archived] = true
      elsif @command == 'l' && @args[0] == 'l'
        options[:local] = true
      elsif @command == 'ac' && @args[0] == 'c'
        options[:completed_only] = true
      end

      options
    end

    def parse_item_desc(desc)
      begin
        Parser.new(desc).call
      rescue InvalidDateFormatError
        puts "Invalid date format."
        exit
      end
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
