class OrganizationsController < ApplicationController
  include PayloadParser
  before_action :authenticate_organization!, except: [:index, :show]
  before_action :restrict_access, only: [:set_api, :import_excel_api, :new_visualization]

  def index
    @organizations = Organization.where(approved: true)
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

  def new_visualization
    @payload = @organization.payload
  end

  def create_visualization
    @organization = Organization.find(params[:organization_id])
    visualization = @organization.build_visualization
    visualization.type = params[:type]
    visualization.name = params[:title]
    visualization.data = create_visualization_data(params[:val], params[:name], params[:loc], params[:type])
    if visualization.save
      redirect_to @organization, notice: 'Vizualizacija uspešno narejena.'
    else
      render 'new_visualization', alert: 'Nekaj je šlo narobe!'
    end
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

  protected

  def url_api
    @payload = @organization.payload
  end

  def excel_api
    render('upload_api')
  end

  private

  def create_visualization_data(val, name, loc, type)
    case type
      when 'pie'
        {val: val, name: name}
      when 'bar'
        {val: val, name: name}
      else
        {name: name, loc: loc}
    end
  end

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
