module Nin
  class Item
    attr_accessor :id, :desc, :date, :tags, :completed

    def initialize(id, desc, date = nil, tags = [], completed = false, formatter = ItemPresenter)
      @id        = id
      @desc      = desc
      self.date  = date # this looks ugly
      @tags      = tags
      @completed = completed
      @formatter = formatter.new(self)
    end

    def date=(date = nil)
      @date = date || Date.today.to_s
    end

    def toggle_completed!
      @completed = !@completed
    end

    def to_s
      @formatter.call
    end

    def to_h
      { 'id' => id, 'desc' => desc, 'tags' => tags, 'completed' => completed }
    end
  end
end
