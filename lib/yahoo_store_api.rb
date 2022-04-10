require "yahoo_store_api/version"
require "yahoo_store_api/helper.rb"
require "yahoo_store_api/item.rb"
require "yahoo_store_api/image.rb"
require "yahoo_store_api/stock.rb"
require "yahoo_store_api/publish.rb"

require "rexml/document"
require "yaml"
require "uri"
require "cgi"
require "faraday"
require "active_support"
require "active_support/core_ext"
require "active_model"

module YahooStoreApi
  class Client
    attr_reader :refresh_token
    include YahooStoreApi::Item
    include YahooStoreApi::Image
    include YahooStoreApi::Stock
    include YahooStoreApi::Publish

    def initialize(seller_id:, application_id:, application_secret:, authorization_code: nil, redirect_uri: nil, refresh_token: nil)
      @seller_id = seller_id
      @application_id = application_id
      @application_secret = application_secret
      @redirect_uri = redirect_uri ? "&redirect_uri=" + CGI.escape(redirect_uri) : nil
      @access_token = refresh_access_token(refresh_token) || get_access_token(authorization_code)
    end

    private

    ACCESS_TOKEN_ENDPOINT = "https://auth.login.yahoo.co.jp/yconnect/v2/token".freeze

    def access_token_connection
      Faraday.new(url: ACCESS_TOKEN_ENDPOINT) do |c|
        c.adapter Faraday.default_adapter
        c.request :authorization, :Basic, Base64.strict_encode64("#{@application_id}:#{@application_secret}")
        c.headers["Content-Type"] = "application/x-www-form-urlencoded;charset=UTF-8"
      end
    end

    def get_access_token(authorization_code)
      param = "grant_type=authorization_code&code=#{authorization_code}#{@redirect_uri}"
      response = access_token_connection.post { |r| r.body = param }
      result = JSON.parse response.body
      @refresh_token = result["refresh_token"]
      result["access_token"]
    end

    def refresh_access_token(refresh_token)
      param = "grant_type=refresh_token&refresh_token=#{refresh_token}"
      response = access_token_connection.post { |r| r.body = param }
      result = JSON.parse response.body
      @refresh_token = refresh_token
      result["access_token"]
    end
  end
end
