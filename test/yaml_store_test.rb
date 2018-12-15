module Nin
  class YamlStoreTest < Minitest::Test
    def setup
      @file   = File.expand_path('./test/todos.yaml')
      @store  = YamlStore.new(@file)
      @hash   = {
        Date.today.to_s => [
          {
            'id' => 1,
            'desc' => 'Item 1 desc',
            'tags' => ['item_tag_1'],
            'completed' => true,
            'archived' => false
          },
          {
            'id' => 2,
            'desc' => 'Item 2 desc',
            'tags' => [],
            'completed' => false,
            'archived' => false
          }
        ],
        Date.today.succ.to_s => [
          {
            'id' => 2,
            'desc' => 'Item 2 desc',
            'tags' => ['item_tag_2'],
            'completed' => true,
            'archived' => true
          }
        ]
      }
    end

    def teardown
      File.delete(@file)
    end

    def test_initialize_creates_new_store
      assert File.exist?(@file)
    end

    def test_read
      @store.write(@hash)

      assert_kind_of Hash, @store.read
    end

    def test_read_empty_file
      assert_kind_of Hash, @store.read
    end

    def test_write
      @store.write(@hash)

      refute File.zero?(@file)
    end
  end
end
