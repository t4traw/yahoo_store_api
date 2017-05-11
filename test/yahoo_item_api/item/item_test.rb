require 'yahoo_store_api'
require 'test_helper'

class YahooStoreApiTest < Minitest::Test
  include TestHelper::Client

  def test_get_item
    VCR.use_cassette('item/getItem') do
      assert_equal 'test_item', client.get_item('test1234').name
    end
  end

  def test_edit_item
    request = {
      item_code: 'test1234',
      name: 'changed_name',
      price: 99999,
      path: 'test_category',
    }
    VCR.use_cassette('item/editItem') do
      assert_equal 'test_item', client.get_item(request[:item_code]).name
      assert_equal 'OK', client.edit_item(request).status
      assert_equal 'changed_name', client.get_item(request[:item_code]).name
    end
  end

  def test_delete_item
    VCR.use_cassette('item/deleteItem') do
      assert_equal 'test_item', client.get_item('test1234').name
      assert_equal 'OK', client.delete_item('test1234').status
      assert_nil client.get_item('test1234')
    end
  end
end
