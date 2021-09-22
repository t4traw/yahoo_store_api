require "yahoo_store_api"
require "test_helper"

class YahooStoreApiTest < Minitest::Test
  include TestHelper::Client

  def test_upload_item_image_pack
    VCR.use_cassette("item/upload_item_image_pack") do
      assert_equal "OK", client.upload_item_image_pack("test/data/sample.zip").status
    end
  end
end
