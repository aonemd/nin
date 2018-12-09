require 'date'

module Nin
  class ParserTest < Minitest::Test
    def setup
      @parser      = Parser.new('Do school homework @tomorrow #school')
      @parsed_data = @parser.call
    end

    def test_extract_date
      assert_equal Date.today.succ.to_s, @parsed_data[1]
      assert_equal 'Do school homework', @parsed_data[0]
    end

    def test_extract_tags
      assert_equal ['school'], @parsed_data[2]
      assert_equal 'Do school homework', @parsed_data[0]
    end
  end
end
