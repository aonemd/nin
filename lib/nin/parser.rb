module Nin
  class Parser
    def initialize(desc)
      @desc = desc
      @date = extract_date
      @tags = extract_tags
    end

    def call
      [@desc, @date, @tags]
    end

    private

    def extract_date
      date_pattern = /@[A-Z0-9.-]+/i
      date         = @desc.scan(date_pattern).last.gsub('@', '')

      strip_tags(date_pattern)

      Chronic.parse(date).strftime('%Y-%m-%d')
    end

    def extract_tags
      tag_pattern = /#[A-Z0-9.-]+/i
      tags        = @desc.scan(tag_pattern).map { |tag| tag.gsub!('#', '') }

      strip_tags(tag_pattern)

      tags
    end

    def strip_tags(pattern)
      @desc.gsub!(pattern, '').strip!
    end
  end
end
