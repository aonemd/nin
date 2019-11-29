require 'test_helper'

module Nin
  class FakeObject
    attr_reader :id

    def initialize(id)
      @id = id
    end

    def ==(other)
      self.id == other.id
    end
  end

  class ArrayExtensionsTest < Minitest::Test
    def setup
      @fake_array = [FakeObject.new(1), FakeObject.new(6), FakeObject.new(2)]
    end

    def test_sorted_by?
      assert [1, 2, 3, 4, 5].sorted_by? { |e| e }
      assert ['a', 'b', 'c'].sorted_by? { |e| e }
      assert ['bb', 'ccc', 'aaaa'].sorted_by? { |e| e.length }

      refute [2, 1, 3, 4, 5].sorted_by? { |e| e }
    end

    def test_limit
      assert_equal [3, 4], [1, 2, 3, 4].limit(2)
      assert_equal [1, 2], [1, 2, 3, 4].limit(-2)
    end

    def test_round_shift
      assert_equal [1, 1], [1, 2, 3].round_shift(2, 1)
      assert_equal [1, 0], [1, 2, 3].round_shift(1, 1)
      assert_equal [1, 2], [1, 2, 3].round_shift(3, 2)
      assert_equal [1, 0], [1, 2, 3].round_shift(1, 100)
      assert_equal [1, 2], [1, 2, 3].round_shift(3, 100)

      assert_equal [3, -1], [1, 2, 3].round_shift(2, -1)
      assert_equal [3, 0], [1, 2, 3].round_shift(3, -1)
      assert_equal [3, -2], [1, 2, 3].round_shift(1, -2)
      assert_equal [3, 0], [1, 2, 3].round_shift(3, -100)
      assert_equal [3, -2], [1, 2, 3].round_shift(1, -100)
    end

    def test_median
      assert_equal 2, [1, 2, 3, 4].median
      assert_equal 5, [1, 5, 7].median
      assert_equal 1, [1].median
      assert_nil [].median
    end

    def test_find_by
      returned = @fake_array.find_by(:id, 1)

      assert_equal FakeObject.new(1), returned
    end

    def test_where
      returned = @fake_array.where(:id, 2)

      assert_instance_of Array, returned
      assert_equal [FakeObject.new(2)], returned
    end

    def test_where_with_block
      returned = @fake_array.where(:id) { |id| id > 1 }

      assert_instance_of Array, returned
      assert_equal @fake_array.drop(1), returned
    end

    def test_where_key_does_not_exist
      assert_raises NoMethodError do
        [1, 2, 3].where(:id, 3)
      end
    end

    def test_where_value_not_found
      returned = @fake_array.where(:id, 999)

      assert_instance_of Array, returned
      assert returned.empty?
    end
  end
end
