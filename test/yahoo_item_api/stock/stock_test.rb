require 'yahoo_store_api'
require 'test_helper'

class YahooStoreApiTest < Minitest::Test
  include YahooStoreApi::Test

  def test_get_stock
    VCR.use_cassette('item/getStock') do
      assert_equal '12', client.get_stock('test1234').quantity
    end
  end
end
