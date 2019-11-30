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
        date_in_words = self.date_to_humanize

        if self.past?
          date_in_words.magenta
        elsif self.today?
          date_in_words.bold.cyan
        else
          date_in_words.cyan
        end
      end

      def tags
        self.tags.map { |tag| tag.dup.prepend('#') }.join(' ').blue
      end
    end
  end
end
