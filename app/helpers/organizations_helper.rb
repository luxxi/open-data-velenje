module OrganizationsHelper
  def create_form_from_json(payload)
    payload.map do |key, value|
      if value.is_a?(Hash)
         if create_form_from_json(value)
           create_fields(key,value)
         end
      elsif value.is_a?(Array)
        create_form_from_json(value.first)
      else
        return true
      end
    end
  end

  private

  def create_fields(key,value)
    "#{key}: " + "Type: #{value[:type]}" + "Description: #{value[:description]}"
  end
end
