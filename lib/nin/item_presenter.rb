module Nin
  class ItemPresenter < SimpleDelegator
    def call
      sprintf("%d \t%s \t%-40s \t%-10s %s",
              id, completed, date, desc, tags).gsub('  ', ' ')
    end

    private

    def completed
      if self.completed
        '[x]'.green
      else
        '[ ]'
      end
    end

    def date
      case self.date
      when Date.today.to_s
        '@today'.bold
      when Date.today.succ.to_s
        '@tomorrow'
      when Date.today.prev_day.to_s
        '@yesterday'
      else
        if self.date < Date.today.to_s
          ('@' << self.date).red
        else
          '@' << self.date
        end
      end.cyan
    end

    def tags
      self.tags.map { |tag| tag.dup.prepend('#') }.join(', ').blue
    end
  end
end
