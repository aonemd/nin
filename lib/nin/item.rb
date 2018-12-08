module Nin
  class Item
    attr_accessor :id, :body

    def initialize(id, body)
      @id   = id
      @body = body
    end

    def to_s
      "#{@id}: #{@body}"
    end
  end
end
