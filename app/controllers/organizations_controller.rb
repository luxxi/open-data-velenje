class OrganizationsController < ApplicationController
  def update
    organization = Organization.friendly.find(params[:id])
    organization.update(organization_params)
    organization.set_updated_at
  end

  private

  def organization_params
    params.required(:organization).permit(:payload)
  end
end
