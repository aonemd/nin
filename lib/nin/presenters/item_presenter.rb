module Nin
  module Presenter
    class ItemPresenter < ::SimpleDelegator
      def call(options = {})
        _id, _completed, _date, _desc, _tags = id, decorate_completed, decorate_date, decorate_desc, decorate_tags

        separating_spaces = options.fetch(:separating_spaces, 2)
        id_spaces         = options.fetch(:longest_id, 1) + separating_spaces
        completed_spaces  = _completed.length + separating_spaces
        date_spaces       = _date.length + (options.fetch(:longest_date, 11) - _date.remove_color.length) + separating_spaces

        sprintf("%-#{id_spaces}d %-#{completed_spaces}s %-#{date_spaces}s %s %s",
                _id, _completed, _date, _desc, _tags)
      end

      private

      def decorate_desc
        if self.archived?
          self.desc.yellow
        elsif self.completed?
          self.desc.white
        else
          self.desc
        end
      end

      def decorate_completed
        if self.completed?
          '[x]'.green
        else
          '[ ]'
        end
      end

      def decorate_date
        date_in_words = '@' << self.date.humanize

        if self.past?
          date_in_words.magenta
        elsif self.today?
          date_in_words.bold.cyan
        else
          date_in_words.cyan
        end
      end

      def decorate_tags
        self.tags.map { |tag| tag.dup.prepend('#') }.join(' ').blue
      end
    end
  end
end
