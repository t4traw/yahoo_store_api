module YahooStoreApi
  module Image
    include YahooStoreApi::Helper

    def upload_item_image_pack(zip_path)
      request = {
        file: Faraday::UploadIO.new(zip_path, "application/zip"),
      }

      handler connection("uploadItemImagePack", with_seller_id: true).post { |r|
        r.body = request
      }
    end
  end
end
