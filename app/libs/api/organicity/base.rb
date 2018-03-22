module Api::Organicity
  class Base < ::Api::Base
    URL = URI.join(ENV["LOCAL_OC_URL"], "/v2").to_s.freeze
    DEFAULT_HEADERS = {
      "Accept" => "application/json",
      "Content-Type" => "application/json",
      "Fiware-Service" => "organicity"
    }.freeze

    def initialize
      @conn = Faraday.new(url: URL, headers: DEFAULT_HEADERS) do |faraday|
        faraday.request :retry, max: 2
        faraday.adapter Faraday.default_adapter
      end
    end
  end
end
