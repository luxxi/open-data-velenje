class OrganizationsController < ApplicationController
  include PayloadParser
  
  def set_api
    @organization = Organization.find(params[:organization_id])
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
      type_name = DataType.find(value).name
      payload = deep_replace(payload, key, type_name, description[key])
    end
    return payload
  end
end
