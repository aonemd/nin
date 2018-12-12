$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)

require 'nin'

require 'minitest/autorun'
require 'minitest/pride'

module TestHelpers
  def capture_stdout(&block)
    original_stdout = $stdout
    $stdout = fake = StringIO.new

    begin
      yield
    ensure
      $stdout = original_stdout
    end

    fake.string
  end

  # check if array is ordered ascendingly by attribute
  def ascending?(array, attribute = nil)
    array.each_cons(2).all? do |left, right|
      if attribute
        left.send(attribute) <= right.send(attribute)
      else
        left <= right
      end
    end
  end
end

include TestHelpers
