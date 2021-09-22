module YahooStoreApi
  module Item
    include YahooStoreApi::Helper

    def upload_item_file(file_path)
      request = {
        type: 1,
        file: Faraday::UploadIO.new(file_path, "text/csv"),
      }

      handler connection("uploadItemFile", with_seller_id: true).post { |r|
        r.body = request
      }
    end
  end
end
