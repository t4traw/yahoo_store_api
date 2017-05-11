require 'yahoo_store_api'
require 'test_helper'

class YahooStoreApiTest < Minitest::Test
  include TestHelper::Client

  def test_get_item
    VCR.use_cassette('item/getItem') do
      assert_equal 'test_item', client.get_item('test1234').name
    end
  end
end
