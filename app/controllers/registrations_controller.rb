class RegistrationsController < Devise::RegistrationsController
  protected

  def after_inactive_sign_up_path_for(resource)
    dataService = ImportOrganizationDataService.new(resource.id)
    json_payload = dataService.parse_payload
    dataService.import!(json_payload)
    OrganizationMailer.new_organization(resource).deliver_now
    approvement_notice_path
  end

  private

  def sign_up_params
    params.require(:organization).permit(:name, :email, :password, :password_confirmation, :url)
  end

  def account_update_params
    params.require(:organization).permit(:name, :email, :password, :password_confirmation, :url, :current_password)
  end
end
