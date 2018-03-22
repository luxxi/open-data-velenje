module Api::Organicity
  class Asset < Base
    def get(asset_uuid)
      api_get("entities/#{asset_uuid}")
    end

    def create(params = {})
      api_post("entities", params)
    end

    def update(asset_uuid, params = {})
      api_put("entities/#{asset_uuid}/attrs", params)
    end
  end
end
