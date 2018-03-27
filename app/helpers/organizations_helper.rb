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

  def display_voda_chart_label_list(organization)
    a = Array.new
    organization.payload[:summary].each do |val|
      a << val[:description][:attr_value] if val[:unit][:attr_value] == "m3/dan"
    end
    return a
  end

  def display_voda_chart_value_list(organization)
    a = Array.new
    organization.payload[:summary].each do |val|
      a << val[:value][:attr_value] if val[:unit][:attr_value] == "m3/dan"
    end
    return a
  end

  def display_chart_time(organization)
    DateTime.parse(organization.payload[:ts][:attr_value]).strftime("%d.%m.%Y, %T")
  end

  def display_energetika_chart_label_list(organization)
    a = Array.new
    organization.payload[:summary].each do |val|
      a << val[:description][:attr_value] if val[:unit][:attr_value] == "MW" && (val[:description][:attr_value] == "P Šoštanj (zadnja vrednost)" || val[:description][:attr_value] == "P Velenje (zadnja vrednost)")
    end
    return a
  end

  def display_energetika_chart_value_list(organization)
    a = Array.new
    organization.payload[:summary].each do |val|
      a << val[:value][:attr_value] if val[:unit][:attr_value] == "MW" && (val[:description][:attr_value] == "P Šoštanj (zadnja vrednost)" || val[:description][:attr_value] == "P Velenje (zadnja vrednost)")
    end
    return a
  end

  def display_bicy_chart_label_list(organization)
    a = Array.new
    organization.payload.map do |k,v|
      a << v[:station][:attr_value] unless k == "ts"
    end
    return a
  end

  def display_bicy_free_chart_value_list(organization)
    a = Array.new
    organization.payload.map do |k,v|
      a << v[:free][:attr_value] unless k == "ts"
    end
    return a
  end

  def display_bicy_all_chart_value_list(organization)
    a = Array.new
    organization.payload.map do |k,v|
      a << v[:available][:attr_value] unless k == "ts"
    end
    return a
  end

  def display_visualization(organization)
    html = ""
    if organization == Organization.find('komunala-velenje-voda')
      html += <<-HTML
        <div class="card-body">
          <canvas id="pie-chart" width="800" height="450"></canvas>
        </div>
        <!-- Custom Chartjs JavaScript -->
        <script>
          $(function () {
              "use strict";

          	// New chart
          	new Chart(document.getElementById("pie-chart"), {
          		type: 'pie',
          		data: {
          		  labels: #{raw display_voda_chart_label_list(organization)},
          		  datasets: [{
          			backgroundColor: ["#36a2eb", "#ff6384","#4bc0c0","#ffcd56","#07ff07", "#ffbb84","#4b44c0","#0f1151","#07aa07"],
          			data: #{display_voda_chart_value_list(organization)}
          		  }]
          		},
          		options: {
          		  title: {
          			display: true,
          			text: "Prečiščena voda (kubični metri na dan). Čas zajetja: #{ raw display_chart_time(organization) }"
          		  }
          		}
          	});
          });
          </script>
        HTML
      elsif organization == Organization.find('komunala-velenje-energetika')
        html += <<-HTML
          <div class="card-body">
            <canvas id="pie-chart" width="800" height="450"></canvas>
          </div>
          <!-- Custom Chartjs JavaScript -->
          <script>
            $(function () {
                "use strict";

            	// New chart
            	new Chart(document.getElementById("pie-chart"), {
            		type: 'pie',
            		data: {
            		  labels: #{raw display_energetika_chart_label_list(organization)},
            		  datasets: [{
            			backgroundColor: ["#36a2eb", "#ff6384"],
            			data: #{display_energetika_chart_value_list(organization)}
            		  }]
            		},
            		options: {
            		  title: {
            			display: true,
            			text: "Proizvedena energija (MW). Čas zajetja: #{raw display_chart_time(organization)}"
            		  }
            		}
            	});
            });
          </script>
        HTML
      elsif organization == Organization.find('bicy')
        html += <<-HTML
          <div class="card-body">
            <canvas id="bar-chart" width="800" height="450"></canvas>
          </div>
          <script>
            new Chart(document.getElementById("bar-chart"), {
              type: 'bar',
              data: {
                labels: #{raw display_bicy_chart_label_list(organization)},
                datasets: [
                  {
                    label: "Koles na voljo",
                    backgroundColor: ["#88aaf6", "#88aaf6","#88aaf6","#88aaf6","#88aaf6","#88aaf6","#88aaf6","#88aaf6","#88aaf6","#88aaf6","#88aaf6","#88aaf6","#88aaf6","#88aaf6","#88aaf6"],
                    data: #{raw display_bicy_free_chart_value_list(organization)}
                  },
                  {
                    label: "Koles skupaj",
                    backgroundColor: ["#aaa900", "#aaa900","#aaa900","#aaa900","#aaa900","#aaa900","#aaa900","#aaa900","#aaa900","#aaa900","#aaa900","#aaa900","#aaa900","#aaa900","#aaa900"],
                    data: #{raw display_bicy_all_chart_value_list(organization)}
                  }
                ]
              },
              options: {
                legend: { display: false },
                title: {
                display: true,
                text: 'Število mest in število koles na voljo na posamezni postaji'
                },
                scales: {
                  xAxes: [{
                      stacked: true
                  }],
                  yAxes: [{
                      stacked: true
                  }]
                }
              }
            });
          </script>
        HTML
      elsif organization == Organization.find('mic')
        html += <<-HTML
          <div id="map" style="width: 800px; height: 450px"></div>
          <script>
            function initMap() {
              var mic = {lat: #{organization.payload[:location][:attr_value].tr(' ','').split(",")[0]}, lng: #{organization.payload[:location][:attr_value].tr(' ','').split(",")[1]}};
              var map = new google.maps.Map(document.getElementById('map'), {
                zoom: 15,
                center: mic
              });
              var contentString = '<div id="content">'+
                '<div id="siteNotice">'+
                '</div>'+
                '<h1 id="firstHeading" class="firstHeading">Mic</h1>'+
                '<div id="bodyContent">'+
                '<p>Zračni tlak: #{organization.payload[:air_pressure][:attr_value]}mBar</p>'+
                '<p>Temperatura zraka: #{organization.payload[:temp_air][:attr_value]}°C</p>'+
                '<p>Podatki zajeti ob: #{DateTime.parse(organization.payload[:timestamp][:attr_value]).strftime("%d.%m.%Y, %T")}</p>'+
                '</div>'+
                '</div>';

              var infowindow = new google.maps.InfoWindow({
                content: contentString
              });

              var marker = new google.maps.Marker({
                position: mic,
                map: map
              });

              marker.addListener('click', function() {
                infowindow.open(map, marker);
              });
            }
          </script>
          <script async defer
          src="https://maps.googleapis.com/maps/api/js?key=AIzaSyCk9BfjyX7FrTgenjqYSx28i2RSGOL_5tM&callback=initMap">
          </script>
        HTML
      else
        html += <<-HTML
          <em>
            Ta organizacije še nima vizualizacije.
          </em>
        HTML
      end
      html.html_safe
  end
end
