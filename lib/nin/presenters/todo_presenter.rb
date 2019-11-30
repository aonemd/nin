module Nin
  module Presenter
    class TodoPresenter < ::SimpleDelegator
      def call
        formatting_options = { separating_spaces: 4,
                               longest_id: self.map(&:id).max.length,
                               longest_date: 11 }

        self.map do |item|
          Presenter::ItemPresenter.new(item).call(formatting_options)
        end
      end
    end
  end
end
