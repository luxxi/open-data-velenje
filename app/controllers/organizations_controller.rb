class OrganizationsController < ApplicationController
  include PayloadParser
  before_action :authenticate_organization!, except: [:index, :show]
  before_action :restrict_set_api, only: :set_api

  def index
    @organizations = Organization.where(approved: true)
  end

  def show
    @organization = Organization.find(params[:id])
  end

  def set_api
    @payload = @organization.payload
  end

  def update
    @organization = Organization.find(params[:id])

    safe_params = params.permit(type: params[:type].keys, description: params[:description].keys)
    hash = safe_params.to_h
    payload = @organization.payload
    payload = update_payload(payload, hash[:type], hash[:description])
    if(@organization.update(payload: payload))
      redirect_to root_path, notice: 'Uspešno posodobljeno.'
    else
      render 'set_api', notice: 'Nekaj je šlo narobe.'
    end
  end

  private

  def update_payload(payload, type, description)
    type.map do |key, value|
      type_data = DataType.find(value).data
      payload = deep_replace(payload, key, type_data, description[key])
    end
    payload
  end

  def restrict_set_api
    @organization = Organization.find(params[:organization_id])
    if current_organization != @organization
      redirect_to root_path, alert: 'Nedovoljen dostop.'
    end
  end
end
