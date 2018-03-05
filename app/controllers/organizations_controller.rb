class OrganizationsController < ApplicationController
  def set_api
    @organization = Organization.find(params[:organization_id])
    @payload = @organization.payload
  end
end
