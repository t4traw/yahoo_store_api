require 'rexml/document'

module YahooStoreApi
  module Publish
    include YahooStoreApi::Helper

    def reserve_publish(mode: 1, reserve_time: nil)
      conn = Faraday.new(url: ENDPOINT + 'reservePublish') do |c|
        c.adapter Faraday.default_adapter
        c.headers['Authorization'] = "Bearer " + @access_token
      end
      request = []
      request << "seller_id=#{@seller_id}"
      request << "mode=#{mode}"
      request << "seller_id=#{reserve_time}" if reserve_time

      result = conn.post {|r| r.body = request.join('&')}

      handler result
    end

  end
end
