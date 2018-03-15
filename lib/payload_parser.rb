module PayloadParser
  # parses fields from payload, so you can add DataTypes, display documentation,...
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

  # updates payload with new type and description values
  def deep_replace(obj, key, type, description)
    if obj.respond_to?(:key?) && obj.key?(key)
      obj[key][:type] = type
      obj[key][:description] = description
      return obj
    end

    if obj.is_a? Hash
      obj.map do |k, v|
       obj[k] = deep_replace(v, key, type, description)
      end
      return obj
    elsif obj.is_a? Array
      obj.each_with_index do |o, i|
        obj[i] = deep_replace(o, key, type, description)
      end
      return obj
    end
  end

  private

  def create_fields(value)
    {
      type: value[:type],
      description: value[:description]
    }
  end
end
