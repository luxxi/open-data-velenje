class OrganizationsController < ApplicationController
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

  def deep_replace(obj, key, type, description)
    if obj.respond_to?(:key?) && obj.key?(key)
      obj[key][:type] = type
      obj[key][:description] = description
      return obj
    end

    if obj.is_a? Hash
      obj.find { |a| obj[a.first] = deep_replace(a.last, key, type, description) }
      return obj
    elsif obj.is_a? Array
      obj.each_with_index do |o, i|
        obj[i] = deep_replace(o, key, type, description)
      end
      return obj
    end
  end
end
