module Api::Organicity
  class Asset < Base
    def get(user_id)
      api_get("entities/#{user_id}")
    end

    def create(params = {})
      api_post("entities", params)
    end

    def update(user_uuid, params = {})
      api_put("entities/#{user_uuid}", params)
    end
  end
end
