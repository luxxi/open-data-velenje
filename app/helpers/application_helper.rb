module ApplicationHelper
  def display_session_links
    if organization_signed_in?
      link_to 'Sign out', destroy_organization_session_path, method: :delete
    else
      link_to 'Sign in', new_organization_session_path
    end
  end

  def display_menu_toggle_button
    '<li><a class="menu-brand white" id="menu-toggle"><span class="ti-view-grid"></span></a></li>'.html_safe
  end

  def display_mobile_menu_toggle_button
    '<button type="button" class="navbar-toggle" data-toggle="collapse" data-target=".navbar-collapse"><span class="sr-only">Toggle navigation</span><span class="icon-bar"></span><span class="icon-bar"></span><span class="icon-bar"></span></button>'.html_safe
  end

  def display_dropdown_options
    if organization_signed_in?
      html = "<li>#{link_to '<i class="fa fa-user fa-fw"></i> Profil'.html_safe, organization_path(current_organization)}</li>"
      html += "<li>#{link_to '<i class="fa fa-gear fa-fw"></i> Nastavitve'.html_safe, edit_organization_registration_path}</li>"
      html += "<li>#{link_to '<i class="fa fa-sign-out fa-fw"></i> Logout'.html_safe, destroy_organization_session_path, method: :delete}</li>"
      return html.html_safe
    else
      "<li>#{link_to '<i class="fa fa-sign-in fa-fw"></i> Prijava/Registracija'.html_safe, new_organization_session_path}</li>".html_safe
    end

  end

  def display_messages
    html = ''
    html += "<div class='alert alert-success alert-dismissable'><button type='button' class='close' data-dismiss='alert' aria-hidden='true'>×</button>#{notice}</div>" if notice
    html += "<div class='alert alert-warning alert-dismissable'><button type='button' class='close' data-dismiss='alert' aria-hidden='true'>×</button>#{alert}</div>" if alert
    html.html_safe
  end
end
