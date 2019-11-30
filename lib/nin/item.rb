module Nin
  class Item
    attr_accessor :id, :desc, :date, :tags, :completed, :archived

    def initialize(id,
                   desc,
                   date = Date.today.to_s,
                   tags = [],
                   completed = false,
                   archived = false,
                   formatter = Presenter::ItemPresenter)

      @id        = id
      @desc      = desc
      @date      = date || Date.today.to_s
      @tags      = tags
      @completed = completed
      @archived  = archived
      @formatter = formatter.new(self)
    end

    def edit(desc, date = nil, tags = [])
      self.desc = desc
      self.date = date unless date.nil?
      self.tags.concat(tags)
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

    def completed?
      @completed
    end

    def archived?
      @archived
    end

    def due?
      @date < Date.today.to_s
    end
  end
end
