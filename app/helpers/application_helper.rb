module ApplicationHelper
  def display_session_links
    if organization_signed_in?
      link_to 'Sign out', destroy_organization_session_path, method: :delete
    else
      link_to 'Sign in', new_organization_session_path
    end
  end
end
