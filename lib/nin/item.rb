module Nin
  class Item
    attr_accessor :id, :desc

    def initialize(id, desc)
      @id   = Integer(id)
      @desc = desc
    end

    def to_s
      "#{@id}: #{@desc}"
    end
  end
end
