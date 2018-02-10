class OrganizationDataPoolWorker
  include Sidekiq::Worker
  require 'nokogiri'
  require 'httparty'

  def perform(id)
    organization = Organization.find(id)
    url = organization.url
    response = HTTParty.get(url, verify: false).parsed_response
    if response.class == Hash
      json_payload = response
    else
      doc = Nokogiri::HTML(response)
      json_payload = JSON.parse(doc.at('body').content)
    end
    organization.update(payload: json_payload)
  end
end
