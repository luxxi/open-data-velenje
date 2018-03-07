module OrganizationsHelper
  def create_form_from_payload(payload,f)
    hash = crate_hash_from_payload(payload)
    html=""
    hash.map do |key, value|
      html += '<div>'
      html += f.label key.to_sym
      html += label_tag value.keys.first.to_sym
      html += select_tag value.keys.first.to_sym, options_for_select(DataType.all.collect{ |t| [t.name, t.id] })
      html += label_tag value.keys.last.to_sym
      html += text_field_tag value.keys.last.to_sym
      html += '</div>'
    end
    html.html_safe
  end

  private

  def crate_hash_from_payload(payload)
    hash = Hash.new
    payload.map do |key, value|
      if value.is_a?(Hash)
         if hash = hash.merge(crate_hash_from_payload(value))
           hash[key] = create_fields(value) unless value[:type].nil? && value[:description].nil?
         end
      elsif value.is_a?(Array)
        hash = hash.merge(crate_hash_from_payload(value.first))
      else
        return hash
      end
    end
    return hash
  end

  def create_fields(value)
    {
      type: value[:type],
      description: value[:description]
    }
  end
end
