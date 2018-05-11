class OrganizationMailer < ApplicationMailer
  def account_approved(organization)
    @organization = organization
    mail(to: @organization.email, subject: 'Vaša organizacija je bila potrjena.')
  end

  def new_organization(organization)
    @organization = organization
    mail(to: 'open-data@velenje.si', subject: 'Nova organizacija zahteva dostop.')
  end
end
