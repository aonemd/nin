module Nin
  module Integration
    class Synchronizer
      attr_reader :timeout_interval

      def initialize(client, timeout_interval = nil)
        @client           = client
        @timeout_interval = timeout_interval
      end
    end
  end
end
