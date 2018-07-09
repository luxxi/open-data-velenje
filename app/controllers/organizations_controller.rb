class OrganizationsController < ApplicationController
  include PayloadParser
  before_action :authenticate_organization!, except: [:index, :show]
  before_action :restrict_access, only: [:set_api, :import_excel_api]

  def index
    @organizations = Organization.not_admin.where(approved: true)
  end

  def show
    @organization = Organization.find(params[:id])
  end

  def set_api
    if @organization.fetch_type == 'excel'
      excel_api
    else
      url_api
    end
  end

  def import_excel_api
    @organization.import_excel(params[:file])
    redirect_to @organization, notice: 'Api uspešno naložen.'
  end

  def update
    @organization = Organization.find(params[:id])
    safe_params = params.permit(attr_type: params[:attr_type].keys, attr_description: params[:attr_description].keys, skip_attribute: params[:skip_attribute].keys)
    hash = safe_params.to_h
    hash = booleanize_skip_attribute_keys(hash)

    payload = @organization.payload
    payload = update_payload(payload, hash[:attr_type], hash[:attr_description], hash[:skip_attribute])
    if(@organization.update(payload: payload))
      redirect_to root_path, notice: 'Uspešno posodobljeno.'
    else
      render 'set_api', notice: 'Nekaj je šlo narobe.'
    end
  end

  def download_excel_template
    send_file("#{Rails.root}/public/open_data_velenje_template.xlsx")
  end

  def administration
    return unless current_organization.admin?
    @organizations = Organization.not_admin
  end

  def switch
    return unless current_organization.admin?
    sign_in(:organization, Organization.find(params[:organization]))
    redirect_to root_url
  end

  def approve
    return unless current_organization.admin?
    organization = Organization.find(params[:organization_id])
    organization.update(approved: true)
    redirect_to administration_organizations_path
  end

  def disapprove
    return unless current_organization.admin?
    organization = Organization.find(params[:organization_id])
    organization.update(approved: false)
    redirect_to administration_organizations_path
  end

  protected

  def url_api
    @payload = @organization.payload
  end

  def excel_api
    render('upload_api')
  end

  private

  def booleanize_skip_attribute_keys(hash)
    hash[:skip_attribute].keys.each do |key|
      if hash[:skip_attribute][key] == '0'
        hash[:skip_attribute][key] = false
      else
        hash[:skip_attribute][key] = true
      end
    end
    hash
  end

  def update_payload(payload, attr_type, attr_description, skip_attribute)
    attr_type.map do |key, value|
      payload = deep_replace(payload, key, value, attr_description[key], skip_attribute[key])
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
