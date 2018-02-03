class OrganizationsController < ApplicationController
  def update
    organization = Organization.friendly.find(params[:id])
    organization.update(organization_params)
  end

  private

  def organization_params

  end
end
