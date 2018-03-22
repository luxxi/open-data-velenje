class OrganizationDataPoolWorker
  include Sidekiq::Worker
  sidekiq_options retry: false
  require 'nokogiri'
  require 'httparty'

  def perform(id)
    dataService = ImportOrganizationDataService.new(id)
    json_payload = dataService.parse_payload
    dataService.import!(json_payload)
  end
end
