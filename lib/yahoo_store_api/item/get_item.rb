require 'rexml/document'

module YahooStoreApi
  module Item
    include YahooStoreApi::Helper

    def get_item(item_code)
      conn = Faraday.new(url: ENDPOINT + 'getItem' + "?seller_id=#{@seller_id}&item_code=" + item_code) do |c|
        c.adapter Faraday.default_adapter
        c.headers['Authorization'] = "Bearer " + @access_token
      end
      handler conn.get
    end

  end
end
