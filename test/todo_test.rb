require 'test_helper'

module Nin
  class FakeStore
    def read
      {
        Date.today.prev_day.to_s => [
          {
            'id' => 1,
            'desc' => 'Fake Task 1 desc',
            'tags' => ['fake_tag'],
            'completed' => false,
            'archived' => false
          }
        ],
        Date.today.to_s => [
          {
            'id' => 2,
            'desc' => 'Fake Task 2 desc',
            'tags' => ['school'],
            'completed' => true,
            'archived' => false
          },
          {
            'id' => 3,
            'desc' => 'Fake Task 3 desc',
            'tags' => [],
            'completed' => false,
            'archived' => false
          },
          {
            'id' => 4,
            'desc' => 'Fake Task 4 desc',
            'tags' => [],
            'completed' => false,
            'archived' => false
          }
        ],
        Date.today.succ.to_s => [
          {
            'id' => 5,
            'desc' => 'Fake Task 5 desc',
            'tags' => ['fake_tag'],
            'completed' => true,
            'archived' => true
          },
          {
            'id' => 6,
            'desc' => 'Fake Task 6 desc',
            'tags' => [],
            'completed' => false,
            'archived' => false
          }
        ]
      }
    end

    def write(hash)
      'Wrote to store successfully'
    end
  end

  class TodoTest < Minitest::Test
    def setup
      @store = FakeStore.new()
      @todo  = Nin::Todo.new(@store)
    end

    def test_initialize_loads_items
      refute_empty @todo.items
    end

    def test_initialize_loads_items_sorted
      assert @todo.items.sorted_by? { |item| [item.date, item.id] }
    end

    def test_initialize_orders_items_by_date
      assert ascending?(@todo.items, :date)
    end

    def test_list_archived_only_by_default
      expected = Presenter::TodoPresenter.new(@todo.items.where(:archived?, false)).call.join("\n") + "\n"

      assert_output(expected) { @todo.list }
    end

    def test_list_all_with_archived
      @todo.instance_variable_set(:@options, { archived: true })

      expected = Presenter::TodoPresenter.new(@todo.items).call.join("\n") + "\n"

      assert_output(expected) { @todo.list }
    end

    def test_add
      old_item_count = @todo.items.count
      last_id        = @todo.items.sort_by(&:id).last.id

      return_msg  = @todo.add('Fake Task 5 desc', nil, [])
      new_last_id = @todo.send(:last_id)

      assert_equal 1, @todo.items.count - old_item_count
      assert_equal 1, new_last_id - last_id
      assert_equal last_id + 1, new_last_id
      assert_equal 'Wrote to store successfully', return_msg
    end

    def test_add_first_item
      @todo.items = []

      return_msg = @todo.add('Fake Task 1', nil, ['school'])

      assert_equal 1, @todo.items.count
      assert_equal 1, @todo.items.first.id
      assert_equal 'Wrote to store successfully', return_msg
    end

    def test_edit
      item = @todo.items.find_by(:id, 3)
      before_date = item.date

      return_msg = @todo.edit(3, 'Fake Task 3 desc editd', nil, ['new_tag'])

      assert_equal 'Fake Task 3 desc editd', item.desc
      assert_equal before_date, item.date
      assert_equal ['new_tag'], item.tags
      assert_equal 'Wrote to store successfully', return_msg
    end

    def test_edit_not_found
      assert_raises ItemNotFoundError do
        @todo.edit(50, 'Not Found Fake Task', nil, [])
      end
    end

    def test_prioritize_by_1_up
      item_to_prioritize   = @todo.items.find_by(:id, 3).dup
      item_to_deprioritize = @todo.items.find_by(:id, 2).dup

      @todo.prioritize(3)

      item_prioritized   = @todo.items.find_by(:id, 2)
      item_deprioritized = @todo.items.find_by(:id, 3)

      assert_equal item_to_prioritize.desc, item_prioritized.desc
      assert_equal item_to_deprioritize.desc, item_deprioritized.desc
    end

    def test_prioritize_by_1_down
      item_to_prioritize   = @todo.items.find_by(:id, 2).dup
      item_to_deprioritize = @todo.items.find_by(:id, 3).dup

      @todo.prioritize(2, -1)

      item_prioritized   = @todo.items.find_by(:id, 3)
      item_deprioritized = @todo.items.find_by(:id, 2)

      assert_equal item_to_prioritize.desc, item_prioritized.desc
      assert_equal item_to_deprioritize.desc, item_deprioritized.desc
    end

    def test_prioritize_by_n_steps_up
      item_to_prioritize     = @todo.items.find_by(:id, 4).dup
      item_to_deprioritize_1 = @todo.items.find_by(:id, 2).dup
      item_to_deprioritize_2 = @todo.items.find_by(:id, 3).dup

      @todo.prioritize(4, 2)

      item_prioritized     = @todo.items.find_by(:id, 2)
      item_deprioritized_1 = @todo.items.find_by(:id, 3)
      item_deprioritized_2 = @todo.items.find_by(:id, 4)

      assert_equal item_to_prioritize.desc, item_prioritized.desc
      assert_equal item_to_deprioritize_1.desc, item_deprioritized_1.desc
      assert_equal item_to_deprioritize_2.desc, item_deprioritized_2.desc
    end

    def test_prioritize_by_n_steps_down
      item_to_prioritize     = @todo.items.find_by(:id, 2).dup
      item_to_deprioritize_1 = @todo.items.find_by(:id, 3).dup
      item_to_deprioritize_2 = @todo.items.find_by(:id, 4).dup

      @todo.prioritize(2, -2)

      item_prioritized     = @todo.items.find_by(:id, 4)
      item_deprioritized_1 = @todo.items.find_by(:id, 2)
      item_deprioritized_2 = @todo.items.find_by(:id, 3)

      assert_equal item_to_prioritize.desc, item_prioritized.desc
      assert_equal item_to_deprioritize_1.desc, item_deprioritized_1.desc
      assert_equal item_to_deprioritize_2.desc, item_deprioritized_2.desc
    end

    def test_prioritize_single_item_group
      item_to_prioritize = @todo.items.find_by(:id, 1).dup

      @todo.prioritize(1, 1)

      item_prioritized = @todo.items.find_by(:id, 1)

      assert_equal item_to_prioritize.desc, item_prioritized.desc
    end

    def test_prioritize_small_positive_range
      item_to_prioritize   = @todo.items.find_by(:id, 4).dup
      item_to_deprioritize = @todo.items.find_by(:id, 3).dup

      @todo.prioritize(4, 1)

      item_prioritized   = @todo.items.find_by(:id, 3)
      item_deprioritized = @todo.items.find_by(:id, 4)

      assert_equal item_to_prioritize.desc, item_prioritized.desc
      assert_equal item_to_deprioritize.desc, item_deprioritized.desc
    end

    def test_prioritize_small_negative_range
      item_to_prioritize   = @todo.items.find_by(:id, 3).dup
      item_to_deprioritize = @todo.items.find_by(:id, 4).dup

      @todo.prioritize(3, -1)

      item_prioritized   = @todo.items.find_by(:id, 4)
      item_deprioritized = @todo.items.find_by(:id, 3)

      assert_equal item_to_prioritize.desc, item_prioritized.desc
      assert_equal item_to_deprioritize.desc, item_deprioritized.desc
    end

    def test_prioritize_zero_range
      item_to_prioritize   = @todo.items.find_by(:id, 3).dup
      item_to_deprioritize = @todo.items.find_by(:id, 4).dup

      @todo.prioritize(3, 0)

      item_prioritized   = @todo.items.find_by(:id, 3)
      item_deprioritized = @todo.items.find_by(:id, 4)

      assert_equal item_to_prioritize.desc, item_prioritized.desc
      assert_equal item_to_deprioritize.desc, item_deprioritized.desc
    end

    def test_prioritize_large_positive_range
      item_to_prioritize   = @todo.items.find_by(:id, 3).dup
      item_to_deprioritize = @todo.items.find_by(:id, 2).dup

      @todo.prioritize(3, 100)

      item_prioritized   = @todo.items.find_by(:id, 2)
      item_deprioritized = @todo.items.find_by(:id, 3)

      assert_equal item_to_prioritize.desc, item_prioritized.desc
      assert_equal item_to_deprioritize.desc, item_deprioritized.desc
    end

    def test_prioritize_large_positive_range_no_change
      item_to_prioritize = @todo.items.find_by(:id, 2).dup

      @todo.prioritize(2, 100)

      item_prioritized = @todo.items.find_by(:id, 2)

      assert_equal item_to_prioritize.desc, item_prioritized.desc
    end

    def test_prioritize_large_negative_range
      item_to_prioritize   = @todo.items.find_by(:id, 3).dup
      item_to_reprioritize = @todo.items.find_by(:id, 4).dup

      @todo.prioritize(3, -200)

      item_prioritized   = @todo.items.find_by(:id, 4)
      item_reprioritized = @todo.items.find_by(:id, 3)

      assert_equal item_to_prioritize.desc, item_prioritized.desc
      assert_equal item_to_reprioritize.desc, item_reprioritized.desc
    end

    def test_prioritize_large_negative_range_no_change
      item_to_prioritize = @todo.items.find_by(:id, 4).dup

      @todo.prioritize(4, -200)

      item_prioritized = @todo.items.find_by(:id, 4)

      assert_equal item_to_prioritize.desc, item_prioritized.desc
    end

    def test_prioritize_within_archived_items
      item_to_prioritize   = @todo.items.find_by(:id, 6).dup
      item_to_deprioritize = @todo.items.find_by(:id, 5).dup

      @todo.prioritize(6, 1)

      item_prioritized   = @todo.items.find_by(:id, 5)
      item_deprioritized = @todo.items.find_by(:id, 6)

      assert_equal item_to_prioritize.desc, item_prioritized.desc
      assert_equal item_to_deprioritize.desc, item_deprioritized.desc
    end

    def test_complete
      @todo.complete(3)

      assert @todo.items.find_by(:id, 3).completed?
    end

    def test_complete_not_found
      assert_raises ItemNotFoundError do
        @todo.complete(50)
      end
    end

    def test_complete_multiple_items
      @todo.complete(1, 4)

      assert @todo.items.find_by(:id, 1).completed?
      assert @todo.items.find_by(:id, 4).completed?
    end

    def test_archive
      id = @todo.items.find_by(:id, 1).id

      @todo.archive(id)


      assert @todo.items.find_by(:id, 1).archived?
    end

    def test_archive_not_found
      assert_raises ItemNotFoundError do
        @todo.archive(50)
      end
    end

    def test_archive_multiple_items
      @todo.archive(1, 2)

      assert @todo.items.find_by(:id, 1).archived?
      assert @todo.items.find_by(:id, 2).archived?
    end

    def test_delete_archived
      old_item_count      = @todo.items.count
      archived_item_count = @todo.send(:archived_items).count

      @todo.delete_archived

      assert_equal archived_item_count, old_item_count - @todo.items.count
      assert_equal @todo.items.map(&:id), (1..@todo.items.count).to_a
    end

    def test_delete
      old_item_count = @todo.items.count
      @todo.delete(2)

      assert_equal 1, old_item_count - @todo.items.count
    end

    def test_delete_not_found
      assert_raises ItemNotFoundError do
        @todo.delete(50)
      end
    end

    def test_delete_multiple_items
      old_item_count = @todo.items.count
      @todo.delete(2, 3)

      assert_equal 2, old_item_count - @todo.items.count
    end
  end
end
