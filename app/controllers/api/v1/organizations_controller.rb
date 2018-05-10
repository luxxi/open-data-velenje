class Api::V1::OrganizationsController < ApplicationController
  def show
    organization = Organization.find(params[:id])
    render json: organization.filtered_payload
  end
end
