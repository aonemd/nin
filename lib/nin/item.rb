module Nin
  class Item
    attr_accessor :id, :desc, :date, :completed

    def initialize(id, desc, date = nil, completed = false)
      @id        = id
      @desc      = desc
      self.date  = date # this looks ugly
      @completed = completed
    end

    def date=(date = nil)
      @date = date || Date.today.to_s
    end

    def toggle_completed!
      @completed = !@completed
    end

    def to_s
      "#{view_completed} #{@id}: @#{view_date} #{@desc}"
    end

    def to_h
      { 'id' => id, 'desc' => desc, 'completed' => completed }
    end

    private

    def view_date
      case @date
      when Date.today.to_s
        'today'
      when Date.today.succ.to_s
        'tomorrow'
      when Date.today.prev_day.to_s
        'yesterday'
      else
        @date
      end
    end

    def view_completed
      if @completed
        '[x]'
      else
        '[ ]'
      end
    end
  end
end
