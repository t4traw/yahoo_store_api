require 'yahoo_store_api'
require 'test_helper'

class YahooStoreApiTest < Minitest::Test
  include TestHelper::Client

  def test_get_stock
    VCR.use_cassette('stock/getStock') do
      assert_equal '12', client.get_stock('test1234').quantity
    end
  end

  def test_set_stock
    request = {
      item_code: 'test1234',
      quantity: '6'
    }
    VCR.use_cassette('stock/setStock') do
      assert_equal '6', client.set_stock(request).quantity
    end
  end
end
