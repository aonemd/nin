module Nin
  module Presenter
    class ItemPresenter < ::SimpleDelegator
      def call
        sprintf("%d\t%s\t%s   \t%s %s",
                id, completed, date, desc, tags).gsub('  ', ' ')
      end

      private

      def desc
        if self.archived?
          self.desc.yellow
        elsif self.completed?
          self.desc.white
        else
          self.desc
        end
      end

      def completed
        if self.completed?
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
          '@yesterday'.magenta
        else
          if self.due?
            ('@' << self.date).magenta
          else
            '@' << self.date
          end
        end.cyan
      end

      def tags
        self.tags.map { |tag| tag.dup.prepend('#') }.join(' ').blue
      end
    end
  end
end
