module YahooStoreApi
  module Publish
    include YahooStoreApi::Helper

    def reserve_publish(mode: 1, reserve_time: nil)
      request = []
      request << "seller_id=#{@seller_id}"
      request << "mode=#{mode}"
      request << "seller_id=#{reserve_time}" if reserve_time

      handler connection("reservePublish").post { |r|
        r.body = request.join("&")
      }
    end
  end
end
