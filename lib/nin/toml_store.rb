module Nin
  class TomlStore
    DEFAULT_FILE = "#{ENV['HOME']}/.todos.toml"

    attr_reader :file

    def initialize(file = DEFAULT_FILE)
      @file = file

      init_store
    end

    def read
      TomlRB.load_file(@file)
    end

    def write(hash)
      File.open(@file, 'w') do |file|
        file.write(TomlRB.dump(hash))
      end
    end

    private

    def init_store
      return if File.exist?(@file)

      File.open(@file, "w")
    end
  end
end
