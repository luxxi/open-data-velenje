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

  # updates payload with new attr_type and attr_description values
  def deep_replace(obj, key, attr_type, attr_description)
    if obj.respond_to?(:key?) && obj.key?(key)
      obj[key][:attr_type] = attr_type
      obj[key][:attr_description] = attr_description
    end

    if obj.is_a? Hash
      obj.map do |k, v|
       obj[k] = deep_replace(v, key, attr_type, attr_description)
      end
    elsif obj.is_a? Array
      obj.each_with_index do |o, i|
        obj[i] = deep_replace(o, key, attr_type, attr_description)
      end
    end
    return obj
  end

  private

  def create_fields(value)
    {
      attr_type: value[:attr_type],
      attr_description: value[:attr_description]
    }
  end
end
