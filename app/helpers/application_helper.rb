module ApplicationHelper
  def display_session_links
    if organization_signed_in?
      link_to 'Sign out', destroy_organization_session_path, method: :delete
    else
      link_to 'Sign in', new_organization_session_path
    end
  end

  def display_menu_toggle_button
    '<li><a class="menu-brand" id="menu-toggle"><span class="ti-view-grid"></span></a></li>'.html_safe
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
    html += "<p class='notice'>#{notice}</p>" if notice
    html += "<p class='alert'>#{alert}</p>" if alert
    html.html_safe
  end
end
