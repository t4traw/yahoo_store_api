module YahooStoreApi
  module Stock
    include YahooStoreApi::Helper

    def set_stock(hash)
      request = "seller_id=#{@seller_id}&#{URI.encode_www_form(hash)}"

      handler connection('setStock').post { |r|
        r.body = request
      }
    end

  end
end
