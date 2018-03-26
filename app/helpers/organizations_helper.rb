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

  def display_documentation(payload)
    hash = crate_hash_from_payload(payload)
    html = ""
    html += <<-HTML
      <div class="card-body">
        <div class="table-responsive">
          <div class="table-responsive">
            <div class="table-wrapper">
              <div class="table-title theme-bg">
                <div class="row">
                  <div class="col-sm-5">
                    <h2 class="padding-bottom-20">Dokumentacija</h2>
                  </div>
                </div>
              </div>
              <table class="table table-striped table-hover">
                <thead>
                  <tr>
                    <th>Ime polja</th>
                    <th>Opis</th>
                    <th>Podatkovni tip</th>
                  </tr>
                </thead>
                <tbody>
    HTML
    hash.map do |key, value|
      html += <<-HTML
        <tr>
          <td>#{key}</td>
      HTML
      if value[:attr_type].empty?
        html += '<td><em>Še ni nastavljeno</em></td>'
      else
        html += "<td>#{DataType.find_by(data: value[:attr_type]).name}</td>"
      end
      if value[:attr_description].empty?
        html += '<td><em>Še ni nastavljen</em></td>'
      else
        html += "<td>#{value[:attr_description]}</td>"
      end
      html += '</tr>'
    end
    html += <<-HTML
            </tbody>
          </table>
        </div>
      </div>
    </div>
    HTML
    html.html_safe
  end

  def display_chart_label_list(organization)
    a = Array.new
    organization.payload[:summary].each do |val|
      a << val[:description][:attr_value]
    end
    return a
  end

  def display_chart_value_list(organization)
    a = Array.new
    organization.payload[:summary].each do |val|
      a << val[:value][:attr_value]
    end
    return a
  end
end
