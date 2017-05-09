require 'rexml/document'

module YahooStoreApi
  module Helper
    ENDPOINT = "https://circus.shopping.yahooapis.jp/ShoppingWebService/V1/".freeze

    def hash_converter(str)
      ary = str.body.delete('"{}').split(/[:,]/)
      ary.each_slice(2).map{|k, v| [k.to_sym, v]}.to_h
    end

    def handler(response)
      rexml = REXML::Document.new(response.body)
      if rexml.elements['ResultSet/Result']
        response_parser(response)
      elsif rexml.elements['Error/Message']
        puts rexml.elements['Error/Message'].text
      else
        puts rexml
      end
    end

    def response_parser(response)
      xml = REXML::Document.new(response.body)
      xpoint = 'ResultSet/Result'
      attributes = {}
      xml.elements.each(xpoint) do |result|
        result.children.each do |el|
          next if el.to_s.strip.blank?
          if el.has_elements?
            el_ary = el.children.reject{|v| v.to_s.blank?}.map{|v| v.text&.force_encoding('utf-8')}.reject{|v| v.to_s.blank?}
            attributes[el.name.underscore] = el_ary
            begin
              self.define_singleton_method(el.name.underscore) {
                el_ary
              }
            rescue => e
              puts e
            end # begin
          else
            attributes[el.name.underscore] = el.text
            begin
              self.define_singleton_method(el.name.underscore) {
                el.text.force_encoding('utf-8')
              }
            rescue => e
              puts e
            end
          end # if el.has_elements?
        end # result.children.each
        self.define_singleton_method('all') {
          attributes
        }
      end # xml.elements.each(xpoint)
      self
    end # def response_parser

  end
end
