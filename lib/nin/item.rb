module Nin
  class Item
    attr_accessor :body

    def initialize(desc)
      @desc = desc
    end

    def to_s
      "#{@desc}"
    end
  end
end
