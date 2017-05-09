require 'yaml'

module YahooStoreApi
  module Stock
    include YahooStoreApi::Helper

    def get_stock(item_code)
      conn = Faraday.new(url: ENDPOINT + 'getStock') do |c|
        c.adapter Faraday.default_adapter
        c.headers['Authorization'] = "Bearer " + @access_token
      end
      handler conn.post {|r| r.body = "seller_id=#{@seller_id}&item_code=#{item_code}"}
    end

  end
end
