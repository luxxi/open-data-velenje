class HomeController < ApplicationController
  before_action :authenticate_organization!, only: :index

  def index
    @organization = current_organization
    render 'organizations/show'
  end

  def landing
    render layout: 'landing'
  end

  def api
  end

  def approvement_notice
  end
end
