require 'rexml/document'

module YahooStoreApi
  module Helper
    ENDPOINT = "https://circus.shopping.yahooapis.jp/ShoppingWebService/V1/".freeze

    def hash_converter(str)
      ary = str.body.delete('"{}').split(/[:,]/)
      ary.each_slice(2).map{|k, v| [k.to_sym, v]}.to_h
    end

    def response_parser(response)
      xml = REXML::Document.new(response.body)
      xpoint = 'ResultSet/Result'
      xml.elements.each(xpoint) do |result|
        result.children.each do |el|
          next if el.to_s.strip.blank?
          begin
            self.define_singleton_method(el.name.underscore) {
              el.text.force_encoding('utf-8')
            }
          rescue => e
            puts e
          end # begin
        end # result.children.each
      end # xml.elements.each(xpoint)
      self
    end # def response_parser

  end
end
