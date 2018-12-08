module Nin
  class Item
    attr_accessor :id, :body

    def initialize(id, desc)
      @id   = id
      @desc = desc
    end

    def to_s
      "#{@id}: #{@desc}"
    end
  end
end
