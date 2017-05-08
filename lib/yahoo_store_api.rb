require "yahoo_store_api/version"

require 'yaml'
require 'faraday'
require 'active_support'
require 'active_support/core_ext'
require 'active_model'
require 'oga'
require 'hashie'

require 'yahoo_store_api/helper.rb'
require 'yahoo_store_api/item.rb'
require 'yahoo_store_api/stock.rb'

module YahooStoreApi
  class Client
    include YahooStoreApi::Helper
    include YahooStoreApi::Item
    include YahooStoreApi::Stock

    def initialize(seller_id:, application_id:, application_secret:, authorization_code: nil, reflesh_token: nil)
      @seller_id = seller_id
      @application_id = application_id
      @application_secret = application_secret
      @access_token = reflesh_access_token(reflesh_token) || get_access_token(authorization_code)
    end

    private

    ACCESS_TOKEN_ENDPOINT = 'https://auth.login.yahoo.co.jp/yconnect/v1/token'.freeze
    def access_token_connection
      Faraday.new(:url => ACCESS_TOKEN_ENDPOINT) do |c|
        c.adapter Faraday.default_adapter
        c.authorization :Basic, Base64.strict_encode64("#{@application_id}:#{@application_secret}")
        c.headers['Content-Type'] = 'application/x-www-form-urlencoded;charset=UTF-8'
      end
    end

    def get_access_token(authorization_code)
      param = "grant_type=authorization_code&code=#{authorization_code}&redirect_uri=oob"
      obj = access_token_connection.post{|r| r.body = param}
      result = hash_converter(obj)
      result[:access_token]
    end

    def reflesh_access_token(reflesh_token)
      param = "grant_type=refresh_token&refresh_token=#{reflesh_token}"
      obj = access_token_connection.post{|r| r.body = param}
      result = hash_converter(obj)
      result[:access_token]
    end

  end
end
