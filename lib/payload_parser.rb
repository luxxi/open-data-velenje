module PayloadParser
  # parses fields from payload, so you can add DataTypes, display documentation,...
  def crate_hash_from_payload(payload)
    hash = Hash.new
    payload.map do |key, value|
      if value.is_a?(Hash)
         if hash = hash.merge(crate_hash_from_payload(value))
           hash[key] = create_fields(value) unless value[:attr_type].nil? && value[:attr_description].nil?
         end
      elsif value.is_a?(Array)
        hash = hash.merge(crate_hash_from_payload(value.first))
      else
        return hash
      end
    end
    return hash
  end

  # removes skipped attributes from payload
  def filter_skip_attributes_from_payload(obj)
    if obj.is_a? Hash
      obj.map do |k, v|
        if k == "skip_attribute" && v
          return ''
        else
          obj[k] = filter_skip_attributes_from_payload(v)
          if obj[k].blank?
            obj.delete(k)
          end
        end
      end
    elsif obj.is_a? Array
      obj.each_with_index do |o, i|
        obj[i] = filter_skip_attributes_from_payload(o)
      end
    end
    return obj
  end

  # updates payload with new attr_type attr_description and skip_attribute values
  def deep_replace(obj, key, attr_type, attr_description, skip_attribute)
    if obj.respond_to?(:key?) && obj.key?(key)
      obj[key][:attr_type] = attr_type
      obj[key][:attr_description] = attr_description
      obj[key][:skip_attribute] = skip_attribute
    end

    if obj.is_a? Hash
      obj.map do |k, v|
       obj[k] = deep_replace(v, key, attr_type, attr_description, skip_attribute)
      end
    elsif obj.is_a? Array
      obj.each_with_index do |o, i|
        obj[i] = deep_replace(o, key, attr_type, attr_description, skip_attribute)
      end
    end
    return obj
  end

  private

  def create_fields(value)
    {
      attr_type: value[:attr_type],
      attr_description: value[:attr_description],
      attr_value: value[:attr_value],
      skip_attribute: value[:skip_attribute]
    }
  end
end
