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
          #{select_tag value.keys.first.to_s+"[#{key}]", options_for_select(DataType.all.collect{ |t| [t.name, t.data] }.sort, value[:attr_type]), { :class => 'form-control' }}
        </div>
        <div class="form-group">
          #{f.label 'Opis'}
          #{text_field_tag value.keys.second.to_s+"[#{key}]", value[:attr_description], required: true, placeholder: 'Opis', class: 'form-control'}
        </div>
        <div class="form-group">
          #{f.label 'Tega polja ne uvozi v naš API (polje bomo preskočili)'}
          #{check_box value.keys.last.to_s, key, {checked: value[:skip_attribute]}}
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

  def create_visualization_form_from_payload(payload,f)
    hash = crate_hash_from_payload(payload)
    html = '<div class="box-body">'
    html += <<-HTML
    <div class="form-group">
      #{f.label 'Naslov diagrama'}
      #{text_field_tag 'title', '', { required: true, placeholder: 'Naslov diagrama', class: 'form-control' }}
    </div>
    <div class="form-group">
      #{f.label 'Izberi polje, ki vsebuje podatke za prikaz (vrednosti na diagramu)'}
      #{select_tag 'val', options_for_select(hash.keys), { class: 'form-control' }}
    </div>
    <div class="form-group">
      #{f.label 'Izberi polje, ki vsebuje ime podatkov (naslovi vrednosti na diagramu)'}
      #{select_tag 'name', options_for_select(hash.keys), { class: 'form-control' }}
    </div>
    HTML
    html += <<-HTML
      </div>
      <div class="box-footer">
        #{f.submit 'Potrdi', class: 'btn btn-primary'}
      </div>
    HTML
    html.html_safe
  end

  def display_documentation(payload)
    if payload.present?
      hash = crate_hash_from_payload(payload)
      html = ""
      html += <<-HTML
        <div>#{link_to 'Spremeni API dokumentacijo', organization_set_api_path(@organization) if current_organization == @organization}</div>
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
                      <th>Podatkovni tip</th>
                      <th>Opis</th>
                    </tr>
                  </thead>
                  <tbody>
      HTML
      hash.map do |key, value|
        unless value[:skip_attribute]
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
      end
      html += <<-HTML
              </tbody>
            </table>
          </div>
        </div>
      </div>
      HTML
    else
      html = <<-HTML
        <em>
          Ta organizacije še nima nastavljenega API-ja.
        </em>
        <div>#{link_to 'Nastavi API zdaj', organization_set_api_path(@organization) if current_organization == @organization}</div>
      HTML
    end
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

  def display_lokalc_markers(organization)
    html = ""
    organization.payload[:result].each do |v|
      html += <<-HTML
        marker = new google.maps.Marker({
            position: new google.maps.LatLng(#{v[:geoLat][:attr_value]}, #{v[:geoLon][:attr_value]}),
            map: map,
        });
        google.maps.event.addListener(marker, 'click', (function(marker, i) {
          return function() {
            infowindow.setContent('<div id="content">'+
              '<h1 id="firstHeading" class="firstHeading">#{v[:naziv][:attr_value]}</h1>'+
              '</div>');
            infowindow.open(map, marker);
          }
        })(marker, i));
      HTML
    end
    html.html_safe
  end

  def display_visualization(organization)
    html = ""
    if visualization = organization.visualization
      case visualization.type
        when 'pie'
          html += display_pie_chart(organization, visualization)
        when 'bar'
          html += display_bar_chart(organization, visualization)
        else
      end
    elsif organization == Organization.find('komunala-velenje-voda')
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
                }
              }
            });
          </script>
        HTML
      elsif organization == Organization.find('mic')
        html += <<-HTML
          <div id="map" style="width: 100%; height: 450px"></div>
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
      elsif organization == Organization.find('trg-mladosti-stavba-a')
        html += <<-HTML
          <div id="map" style="width: 100%; height: 450px"></div>
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
                '<h1 id="firstHeading" class="firstHeading">Trg Mladosti stavba A</h1>'+
                '<div id="bodyContent">'+
                '<p>Temperatura zraka: #{organization.payload[:temp][:attr_value]}°C</p>'+
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
      elsif organization == Organization.find('trg-mladosti-stavba-b')
        html += <<-HTML
          <div id="map" style="width: 100%; height: 450px"></div>
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
                '<h1 id="firstHeading" class="firstHeading">Trg Mladosti stavba B</h1>'+
                '<div id="bodyContent">'+
                '<p>Temperatura zraka: #{organization.payload[:temp][:attr_value]}°C</p>'+
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
      elsif organization == Organization.find('trg-mladosti-stavba-c')
        html += <<-HTML
          <div id="map" style="width: 100%; height: 450px"></div>
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
                '<h1 id="firstHeading" class="firstHeading">Trg Mladosti stavba C</h1>'+
                '<div id="bodyContent">'+
                '<p>Temperatura zraka: #{organization.payload[:temp][:attr_value]}°C</p>'+
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
      elsif organization == Organization.find('lokalc-postaje')
        html += <<-HTML
          <div id="map" style="width: 100%; height: 450px"></div>
          <script>
            function initMap() {
              var mapOptions = {
                zoom: 12,
                scrollwheel: false,
                center: new google.maps.LatLng(#{organization.payload["result"][1][:geoLat][:attr_value]}, #{organization.payload["result"][1][:geoLon][:attr_value]})
              };

              var map = new google.maps.Map(document.getElementById('map'),
                  mapOptions);


              // MARKERS
              /****************************************************************/
              var markerCount = #{organization.payload["result"].size};
              var infowindow = new google.maps.InfoWindow();
              var marker, i;
              #{display_lokalc_markers(organization)}
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

  def display_organization_gallery(organization)
    html = ""
    if organization == Organization.find('bicy')
      html += <<-HTML
        <div class="col-xs-4 gallery">
          #{image_tag 'gallery/bicy1', class: 'full-height'}
        </div>
        <div class="col-xs-4 gallery">
          #{image_tag 'gallery/bicy2', class: 'full-height'}
        </div>
        <div class="col-xs-4 gallery">
          #{image_tag 'gallery/bicy3', class: 'full-height'}
        </div>
      HTML
    elsif organization == Organization.find('mic')
      html += <<-HTML
        <div class="col-xs-12 gallery">
          #{image_tag 'gallery/mic1', class: 'full-height'}
        </div>
      HTML
    elsif organization == Organization.find('trg-mladosti-stavba-a') || organization == Organization.find('trg-mladosti-stavba-b') || organization == Organization.find('trg-mladosti-stavba-c')
      html += <<-HTML
        <div class="col-xs-12 gallery">
          #{image_tag 'gallery/scv1', class: 'full-height'}
        </div>
      HTML
    elsif organization == Organization.find('komunala-velenje-voda')
      html += <<-HTML
        <div class="col-xs-12 gallery">
          #{image_tag 'gallery/komunala-voda1', class: 'full-height'}
        </div>
      HTML
    elsif organization == Organization.find('komunala-velenje-energetika')
      html += <<-HTML
        <div class="col-xs-12 gallery">
          #{image_tag 'gallery/komunala-energetika1', class: 'full-height'}
        </div>
      HTML
    elsif organization == Organization.find('lokalc-postaje') || organization == Organization.find('lokalc-vozni-red') || organization == Organization.find('lokalc-aktivni-avtobusi')
      html += <<-HTML
      <div class="col-xs-4 gallery">
        #{image_tag 'gallery/lokalc1', class: 'full-height'}
      </div>
      <div class="col-xs-4 gallery">
        #{image_tag 'gallery/lokalc2', class: 'full-height'}
      </div>
      <div class="col-xs-4 gallery">
        #{image_tag 'gallery/lokalc3', class: 'full-height'}
      </div>
      HTML
    end
    html.html_safe
  end

  def display_pie_chart(organization, visualization)
    payload = organization.payload
    name = visualization.name
    labels = []
    data = []
    labels = get_visualization_data(payload, visualization.data[:name])
    data = get_visualization_data(payload, visualization.data[:val])
    html = <<-HTML
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
              labels: #{labels},
              datasets: [{
                backgroundColor: ["#36a2eb", "#ff6384","#4bc0c0","#ffcd56","#07ff07", "#ffbb84","#4b44c0","#0f1151","#07aa07"],
                data: #{data}
              }]
            },
            options: {
              title: {
              display: true,
              text: "#{name}"
              }
            }
          });
        });
        </script>
      HTML
  end

  def display_bar_chart(organization, visualization)
    payload = organization.payload
    name = visualization.name
    labels = []
    data = []
    labels = get_visualization_data(payload, visualization.data[:name])
    data = get_visualization_data(payload, visualization.data[:val])
    html = <<-HTML
      <div class="card-body">
        <canvas id="bar-chart" width="800" height="450"></canvas>
      </div>
      <script>
        new Chart(document.getElementById("bar-chart"), {
          type: 'bar',
          data: {
            labels: #{labels},
            datasets: [{
              backgroundColor: ["#36a2eb", "#ff6384","#4bc0c0","#ffcd56","#07ff07", "#ffbb84","#4b44c0","#0f1151","#07aa07"],
              data: #{data}
            }]
          },
          options: {
            legend: { display: false },
            title: {
            display: true,
            text: "#{name}"
            }
          }
        });
      </script>
    HTML
  end
end
