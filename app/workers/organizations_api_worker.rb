class OrganizationsApiWorker
  include Sidekiq::Worker

  def perform
    Organization.each do |organization|
      OrganizationDataPoolWorker.perform_async(organization.id)
    end
  end
end
