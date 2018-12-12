module Nin
  class Item
    attr_accessor :id, :desc, :date, :tags, :completed, :archived

    def initialize(id,
                   desc,
                   date = nil,
                   tags = [],
                   completed = false,
                   archived = false,
                   formatter = ItemPresenter)

      @id        = id
      @desc      = desc
      self.date  = date # this looks ugly
      @tags      = tags
      @completed = completed
      @archived  = archived
      @formatter = formatter.new(self)
    end

    def date=(date = nil)
      @date = date || Date.today.to_s
    end

    def toggle_completed!
      @completed = !@completed
    end

    def toggle_archived!
      @archived = !@archived
    end

    def to_s
      @formatter.call
    end

    def to_h
      {
        'id' => id,
        'desc' => desc,
        'tags' => tags,
        'completed' => completed,
        'archived'  => archived
      }
    end
  end
end
