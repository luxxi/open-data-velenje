class OrganizationDataPoolWorker
  include Sidekiq::Worker
  sidekiq_options retry: false
  require 'nokogiri'
  require 'httparty'

  def perform(id)
    ImportOrganizationDataService.new(id).import!
  end
end
