module Nin
  class Item
    attr_accessor :id, :desc, :date, :tags, :uid, :completed, :archived

    def initialize(id,
                   desc,
                   date = Date.today,
                   tags = [],
                   uid = nil,
                   completed = false,
                   archived = false,
                   formatter = Presenter::ItemPresenter)

      @id        = id
      @desc      = desc
      @date      = Date.parse_or_return(date) || Date.today
      @tags      = tags
      @uid       = uid
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

    def completed?
      @completed
    end

    def archived?
      @archived
    end

    def past?
      @date < Date.today
    end

    def today?
      @date == Date.today
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
        'archived' => archived,
        'uid' => uid
      }
    end
  end
end
