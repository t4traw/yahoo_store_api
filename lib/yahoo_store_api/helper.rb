module YahooStoreApi
  module Helper
    ENDPOINT = "https://circus.shopping.yahooapis.jp/ShoppingWebService/V1/".freeze

    def hash_converter(str)
      ary = str.body.delete('"{}').split(/[:,]/)
      ary.each_slice(2).map{|k, v| [k.to_sym, v]}.to_h
    end
  end
end
