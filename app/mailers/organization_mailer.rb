class OrganizationMailer < ApplicationMailer
  def account_approved(organization)
    @organization = organization
    mail(to: @organization.email, subject: 'Your organization has been confirmed')
  end

  def new_organization(organization)
    @organization = organization
    mail(to: 'open-data@velenje.si', subject: 'New organization has requested access.')
  end
end
