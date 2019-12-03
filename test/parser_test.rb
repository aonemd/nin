require 'test_helper'

module Nin
  class ParserTest < Minitest::Test
    def setup
      @parser      = Parser.new('Do school homework @tomorrow #school')
      @parsed_data = @parser.call

      @empty_parser      = Parser.new('Do school homework')
      @empty_parsed_data = @empty_parser.call

      @underscore_parser      = Parser.new('Do school homework #school_os_lab')
      @underscore_parsed_data = @underscore_parser.call

      @multi_tag_parser      = Parser.new('Buy #groceries #personal')
      @multi_tag_parsed_data = @multi_tag_parser.call
    end

    def test_extract_date
      assert_equal Date.today.succ, @parsed_data[1]
      assert_equal 'Do school homework', @parsed_data[0]
    end

    def test_extract_date_empty
      assert_nil @empty_parsed_data[1]
      assert_equal 'Do school homework', @empty_parsed_data[0]
    end

    def test_invalid_date_format
      @invalid_date_parser = Parser.new('Do school homework @thrsda')

      assert_raises InvalidDateFormatError do
        @invalid_date_parser.call
      end
    end

    def test_extract_tags
      assert_equal ['school'], @parsed_data[2]
      assert_equal 'Do school homework', @parsed_data[0]
    end

    def test_extract_tags_empty
      assert_empty @empty_parsed_data[2]
      assert_equal 'Do school homework', @empty_parsed_data[0]
    end

    def test_extract_tag_with_underscore
      assert_equal ['school_os_lab'], @underscore_parsed_data[2]
      assert_equal 'Do school homework', @underscore_parsed_data[0]
    end

    def test_extract_multi_tag
      assert_equal ['groceries', 'personal'], @multi_tag_parsed_data[2]
      assert_equal 'Buy', @multi_tag_parsed_data[0]
    end
  end
end
