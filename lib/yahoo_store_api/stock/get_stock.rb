module YahooStoreApi
  module Stock
    include YahooStoreApi::Helper

    def get_stock(item_code)
      handler connection("getStock").post { |r|
        r.body = "seller_id=#{@seller_id}&item_code=#{item_code}"
      }
    end
  end
end
