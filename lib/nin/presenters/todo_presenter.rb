module Nin
  module Presenter
    class TodoPresenter < ::SimpleDelegator
      def call
        return 'No todo items yet. Call `nin add hello world` to add a new item.' if self.empty?

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
