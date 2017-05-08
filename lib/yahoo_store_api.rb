require "yahoo_store_api/version"

require 'yaml'
require 'faraday'
require 'active_support'
require 'active_support/core_ext'
require 'active_model'
require 'oga'
require 'hashie'

module YahooStoreApi
  class YahooStoreApi
    ENDPOINT = "https://circus.shopping.yahooapis.jp/ShoppingWebService/V1/".freeze
    ACCESS_TOKEN_ENDPOINT = 'https://auth.login.yahoo.co.jp/yconnect/v1/token'.freeze

    def initialize(seller_id:, application_id:, application_secret:, authorization_code: nil, reflesh_token: nil)
      @seller_id = seller_id
      @application_id = application_id
      @application_secret = application_secret
      @access_token = reflesh_access_token(reflesh_token) || get_access_token(authorization_code)
    end

    def get_item(item_code)
      conn = Faraday.new(:url => ENDPOINT + 'getItem' + "?seller_id=#{@seller_id}&item_code=" + item_code) do |c|
        c.adapter Faraday.default_adapter
        c.headers['Authorization'] = "Bearer " + @access_token
      end
      result = conn.get
      result.body
    end

    def get_stock(item_code)
      conn = Faraday.new(:url => ENDPOINT + 'getStock') do |c|
          c.adapter Faraday.default_adapter
          c.headers['Authorization'] = "Bearer " + @access_token
        end
      result = conn.post {|r| r.body = "seller_id=#{@seller_id}&item_code=#{item_code}"}
      result.body
    end

    private

    def hash_converter(str)
      ary = str.body.delete('"{}').split(/[:,]/)
      ary.each_slice(2).map {|k, v| [k.to_sym, v] }.to_h
    end

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
