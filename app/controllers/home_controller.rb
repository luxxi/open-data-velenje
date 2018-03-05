class HomeController < ApplicationController
  def index
    @organizations = Organization.where(approved: true)
  end
end
