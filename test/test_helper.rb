$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)

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
end

include TestHelpers
