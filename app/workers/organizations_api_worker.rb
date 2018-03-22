class OrganizationsApiWorker
  include Sidekiq::Worker
  sidekiq_options retry: false

  def perform
    Organization.each do |organization|
      OrganizationDataPoolWorker.perform_async(organization.id)
    end
  end
end
