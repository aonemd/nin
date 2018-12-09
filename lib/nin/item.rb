module Nin
  class Item
    attr_accessor :id, :desc, :completed

    def initialize(id, desc, completed = false)
      @id        = Integer(id)
      @desc      = desc
      @completed = completed
    end

    def toggle_completed!
      @completed = !@completed
    end

    def to_s
      "#{view_completed} #{@id}: #{@desc}"
    end

    private

    def view_completed
      if @completed
        '[x]'
      else
        '[ ]'
      end
    end
  end
end
