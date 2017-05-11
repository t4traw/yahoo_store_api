module YahooStoreApi
  module Item
    include YahooStoreApi::Helper

    def delete_item(str)
      request = "seller_id=#{@seller_id}&item_code=#{URI.encode_www_form_component(str)}"
      
      handler connection('deleteItem').post { |r|
        r.body = request
      }
    end

  end
end
