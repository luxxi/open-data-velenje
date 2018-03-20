class HomeController < ApplicationController
  def index
    @organizations = Organization.where(approved: true)
  end

  def landing
  end

  def approvement_notice
  end
end
