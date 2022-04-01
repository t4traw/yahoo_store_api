module YahooStoreApi
  module Helper
    ENDPOINT = "https://circus.shopping.yahooapis.jp/ShoppingWebService/V1/".freeze

    def connection(method, with_seller_id: false)
      url = ENDPOINT + method
      url += "?seller_id=#{@seller_id}" if with_seller_id

      Faraday.new(url: url) do |c|
        c.request :multipart
        c.request :url_encoded
        c.adapter :net_http
        c.headers["Authorization"] = "Bearer " + @access_token
      end
    end

    def handler(response)
      rexml = REXML::Document.new(response.body)
      if rexml.elements["ResultSet/Result"]
        response_parser(rexml, xpoint: "ResultSet/Result")
      elsif rexml.elements["ResultSet/Status"]
        response_parser(rexml, xpoint: "ResultSet")
      elsif rexml.elements["Error/Message"]
        error_parser(rexml)
      else
        puts rexml
      end
    end

    def response_parser(rexml, xpoint:)
      attributes = {}
      rexml.elements.each(xpoint) do |result|
        result.children.each do |el|
          next if el.to_s.strip.blank?
          if el.has_elements?
            el_ary = el.children.reject { |v| v.to_s.blank? }.map { |v| v.text.try!(:force_encoding, "utf-8") }.reject { |v| v.to_s.blank? }
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
                el.text.try!(:force_encoding, "utf-8")
              }
            rescue => e
              puts e
            end
          end # if el.has_elements?
        end # result.children.each
        self.define_singleton_method("all") {
          attributes
        }
      end # xml.elements.each(xpoint)
      self
    end # def response_parser

    def error_parser(rexml)
      result = {
        status: "NG",
        message: rexml.elements["Error/Message"].text,
      }
      result.each do |k, v|
        self.define_singleton_method(k) { v }
      end
      self.define_singleton_method("all") { result }
      self
    end
  end
end
