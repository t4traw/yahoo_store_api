require "yahoo_store_api"
require "test_helper"

class YahooStoreApiTest < Minitest::Test
  include TestHelper::Client

  def test_reserve_publish
    VCR.use_cassette("publish/test_reserve_publish") do
      assert_equal "OK", client.reserve_publish.status
    end
  end
end
