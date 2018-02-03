class Api::V1::OrganizationsController
  def show
    organization = Organization.friendly.find(params[:id])
    
  end
end
