module Nin
  class ItemPresenter < SimpleDelegator
    def call
      "#{completed} #{id}: #{date} #{tags} #{desc}".gsub('  ', ' ')
    end

    private

    def completed
      if self.completed
        '[x]'
      else
        '[ ]'
      end
    end

    def date
      case self.date
      when Date.today.to_s
        'today'
      when Date.today.succ.to_s
        'tomorrow'
      when Date.today.prev_day.to_s
        'yesterday'
      else
        self.date
      end.prepend('@')
    end

    def tags
      self.tags.map { |tag| tag.dup.prepend('#') }.join(', ')
    end
  end
end
