class OrganizationsController < ApplicationController
  include PayloadParser
  before_action :authenticate_organization!, except: [:index, :show]
  before_action :restrict_access, only: [:set_api, upload_api, excel_api]

  def index
    @organizations = Organization.where(approved: true)
  end

  def show
    @organization = Organization.find(params[:id])
  end

  def set_api
    @payload = @organization.payload
  end

  def import_excel_api
    Organization.import_excel(params[:file])
    redirect_to @organization, notice: 'Api uspešno naložen.'
  end

  def upload_api
  end

  def update
    @organization = Organization.find(params[:id])

    safe_params = params.permit(attr_type: params[:attr_type].keys, attr_description: params[:attr_description].keys)
    hash = safe_params.to_h
    payload = @organization.payload
    payload = update_payload(payload, hash[:attr_type], hash[:attr_description])
    if(@organization.update(payload: payload))
      redirect_to root_path, notice: 'Uspešno posodobljeno.'
    else
      render 'set_api', notice: 'Nekaj je šlo narobe.'
    end
  end

  private

  def update_payload(payload, attr_type, attr_description)
    attr_type.map do |key, value|
      payload = deep_replace(payload, key, value, attr_description[key])
    end
    payload
  end

  def restrict_access
    @organization = Organization.find(params[:organization_id])
    if current_organization != @organization
      redirect_to root_path, alert: 'Nedovoljen dostop.'
    end
  end
end
