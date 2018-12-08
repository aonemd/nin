module Nin
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
end
