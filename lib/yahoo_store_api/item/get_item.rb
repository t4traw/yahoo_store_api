module YahooStoreApi
  module Item
    include YahooStoreApi::Helper

    def get_item(item_code)
      handler connection('getItem').get { |r|
        r.params['seller_id'] = @seller_id
        r.params['item_code'] = item_code
      }
    end

  end
end
