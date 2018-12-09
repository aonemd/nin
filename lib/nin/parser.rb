module Nin
  class Parser
    def initialize(desc)
      @desc = desc
      @date = extract_date
    end

    def call
      [@desc, @date]
    end

    private

    def extract_date
      date_pattern = /@[A-Z0-9.-]+/i
      date         = @desc.scan(date_pattern).last.gsub('@', '')

      strip_tags(date_pattern)

      Chronic.parse(date).strftime('%Y-%m-%d')
    end

    def strip_tags(pattern)
      @desc.gsub!(pattern, '').strip!
    end
  end
end
