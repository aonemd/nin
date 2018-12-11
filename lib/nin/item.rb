module Nin
  class Item
    attr_accessor :id, :desc, :date, :tags, :completed

    def initialize(id, desc, date = nil, tags = [], completed = false)
      @id        = id
      @desc      = desc
      self.date  = date # this looks ugly
      @tags      = tags
      @completed = completed
    end

    def date=(date = nil)
      @date = date || Date.today.to_s
    end

    def toggle_completed!
      @completed = !@completed
    end

    def to_s
      "#{view_completed} #{@id}: @#{view_date} #{view_tags} #{@desc}".gsub('  ', ' ')
    end

    def to_h
      { 'id' => id, 'desc' => desc, 'tags' => tags, 'completed' => completed }
    end

    private

    def view_completed
      if @completed
        '[x]'
      else
        '[ ]'
      end
    end

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

    def view_tags
      @tags.map { |tag| tag.dup.prepend('#') }.join(', ')
    end
  end
end
