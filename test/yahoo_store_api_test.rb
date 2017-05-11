require 'test_helper'

class YahooStoreApiTest < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::YahooStoreApi::VERSION
  end
end
