module YahooStoreApi
  module Item
    include YahooStoreApi::Helper

    def edit_item(hash)
      request = "seller_id=#{@seller_id}&#{URI.encode_www_form(hash)}"
      
      handler connection('editItem').post { |r|
        r.body = request
      }
    end

  end
end
