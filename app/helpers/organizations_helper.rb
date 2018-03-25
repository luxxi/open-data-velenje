module OrganizationsHelper
  include PayloadParser

  def create_form_from_payload(payload,f)
    hash = crate_hash_from_payload(payload)
    html = '<div class="box-body">'
    hash.map do |key, value|
      html += <<-HTML
        <div class="form-group">
          <h2>#{key}</h2>
          #{f.label 'Podatkovni tip'}
          #{select_tag value.keys.first.to_s+"[#{key}]", options_for_select(DataType.all.collect{ |t| [t.name, t.id] }.sort), { :class => 'form-control' }}
        </div>
        <div class="form-group">
          #{f.label 'Opis'}
          #{text_field_tag value.keys.last.to_s+"[#{key}]", '', required: true, placeholder: 'Opis', class: 'form-control'}
        </div>
        <hr />
      HTML
    end
    html += <<-HTML
      </div>
      <div class="box-footer">
        #{f.submit 'Potrdi', class: 'btn btn-primary'}
      </div>
    HTML
    html.html_safe
  end
end
