class RegistrationsController < Devise::RegistrationsController
  protected

  def after_inactive_sign_up_path_for(resource)
    ImportOrganizationDataService.new(resource.id).import!
    OrganizationMailer.new_organization(resource).deliver_now
    approvement_notice_path
  end

  private

  def sign_up_params
    params.require(:organization).permit(:name, :description, :email, :password, :password_confirmation, :url, :fetch_type)
  end

  def account_update_params
    params.require(:organization).permit(:name, :description, :email, :password, :password_confirmation, :url, :current_password)
  end
end
