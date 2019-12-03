module Nin
  class Parser
    def initialize(desc)
      @desc = desc
    end

    def call
      [@desc, extract_date, extract_tags]
    end

    private

    def extract_date
      date_pattern = /@[A-Z0-9.,-]+/i
      date         = @desc.scan(date_pattern).last

      return nil if date.nil?

      date.gsub!('@', '')
      strip_tags(date_pattern)

      begin
        Chronic.parse(date).to_date
      rescue NoMethodError
        raise InvalidDateFormatError
      end
    end

    def extract_tags
      tag_pattern = /#[A-Z0-9_]+/i
      tags        = @desc.scan(tag_pattern).map { |tag| tag.gsub!('#', '') }

      strip_tags(tag_pattern)

      tags
    end

    def strip_tags(pattern)
      @desc.gsub!(pattern, '')
      @desc.strip!
    end
  end
end
