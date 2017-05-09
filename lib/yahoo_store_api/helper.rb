module YahooStoreApi
  module Helper
    ENDPOINT = "https://circus.shopping.yahooapis.jp/ShoppingWebService/V1/".freeze

    def hash_converter(str)
      ary = str.body.delete('"{}').split(/[:,]/)
      ary.each_slice(2).map{|k, v| [k.to_sym, v]}.to_h
    end

    def response_parser(response)
      oga = Oga.parse_xml(response.body)
      xpoint = 'ResultSet/Result'
      oga.xpath(xpoint).each do |x|
        x.children.each do |el|
          begin
            self.define_singleton_method(el.name.underscore) {
              el.children.text.force_encoding('utf-8')
            }
          rescue => e
            puts e
          end
        end # x.children.each
      end # oga.xpath(xpoint).each
      self
    end # def response_parser

  end
end
