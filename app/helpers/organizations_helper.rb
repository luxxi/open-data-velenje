module OrganizationsHelper
  include PayloadParser

  def create_form_from_payload(payload,f)
    hash = crate_hash_from_payload(payload)
    html=""
    hash.map do |key, value|
      html += '<div>'
      html += f.label key
      html += f.label value.keys.first
      html += select_tag value.keys.first.to_s+"[#{key}]", options_for_select(DataType.all.collect{ |t| [t.name, t.id] })
      html += f.label value.keys.last
      html += text_field_tag value.keys.last.to_s+"[#{key}]", '', required: true
      html += '</div>'
    end
    html += '<div>'
    html += f.submit 'Potrdi'
    html += '</div>'
    html.html_safe
  end
end
