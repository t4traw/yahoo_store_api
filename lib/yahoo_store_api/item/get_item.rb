module YahooStoreApi
  module Item
    include YahooStoreApi::Helper

    def get_item(item_code)
      handler connection('getItem', params: "?seller_id=#{@seller_id}&item_code=#{item_code}").get
    end

  end
end
