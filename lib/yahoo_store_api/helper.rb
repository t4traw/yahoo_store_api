module YahooStoreApi
  module Helper

    ENDPOINT = "https://circus.shopping.yahooapis.jp/ShoppingWebService/V1/".freeze
    def connection(method, params: '')
      Faraday.new(url: ENDPOINT + method + params) do |c|
        c.adapter Faraday.default_adapter
        c.headers['Authorization'] = "Bearer " + @access_token
      end
    end

    def handler(response)
      rexml = REXML::Document.new(response.body)
      # method = response.to_hash[:url].to_s.split('/').last
      if rexml.elements['ResultSet/Result']
        response_parser(rexml, xpoint: 'ResultSet/Result')
      elsif rexml.elements['ResultSet/Status']
        response_parser(rexml, xpoint: 'ResultSet')
      elsif rexml.elements['Error/Message']
        puts rexml.elements['Error/Message'].text
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
            el_ary = el.children.reject{|v| v.to_s.blank?}.map{|v| v.text.try!(:force_encoding, 'utf-8')}.reject{|v| v.to_s.blank?}
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
                el.text.try!(:force_encoding, 'utf-8')
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
