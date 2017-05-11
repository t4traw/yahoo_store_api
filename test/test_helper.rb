$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'yahoo_store_api'

require 'minitest/autorun'
require "minitest/reporters"
Minitest::Reporters.use!

require 'webmock/minitest'
require 'vcr'
require 'dotenv/load'

VCR.configure do |c|
  c.cassette_library_dir = 'test/cassettes'
  c.hook_into :webmock
  c.filter_sensitive_data('<YOUR_SELLER_ID>') { ENV['YOUR_SELLER_ID'] }
  c.filter_sensitive_data('<YOUR_APPLICATION_ID>') { ENV['YOUR_APPLICATION_ID'] }
  c.filter_sensitive_data('<YOUR_APPLICATION_SECRET>') { ENV['YOUR_APPLICATION_SECRET'] }
  c.filter_sensitive_data('<YOUR_REFRESH_TOKEN>') { ENV['YOUR_REFRESH_TOKEN'] }
  c.filter_sensitive_data('<BASIC_AUTH>') { ENV['BASIC_AUTH'] }
  c.before_record do |i|
   i.request.headers.delete('Authorization')
   i.response.body.sub!(/\"access_token\":\".*\"}$/, '"access_token":"<ACCESS_TOKEN>"}')
  end
end

module YahooStoreApi
  module Test
    def client
       YahooStoreApi::Client.new(
        seller_id: ENV['YOUR_SELLER_ID'],
        application_id: ENV['YOUR_APPLICATION_ID'],
        application_secret: ENV['YOUR_APPLICATION_SECRET'],
        refresh_token: ENV['YOUR_REFRESH_TOKEN']
      )
    end
  end
end
