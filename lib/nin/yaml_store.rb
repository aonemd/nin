module Nin
  class YamlStore
    DEFAULT_FILE = "#{ENV['HOME']}/.todos.yaml"

    def initialize(file = DEFAULT_FILE)
      @file = file

      init_store
    end

    def read
      Psych.load_file(@file) || {}    # Psych returns false if the file is empty
    end

    def write(hash)
      File.open(@file, 'w') do |file|
        file.write(Psych.dump(hash))
      end
    end

    private

    def init_store
      return if File.exist?(@file)

      File.open(@file, "w")
    end
  end
end
