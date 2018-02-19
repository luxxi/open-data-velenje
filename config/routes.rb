Rails.application.routes.draw do
  devise_for :organizations
  namespace :api do
    namespace :v1 do
      resources :organizations, only: :show
    end
  end

  resources :organizations, except: [:index, :edit, :show, :new, :create, :destroy] do
    get 'set_api'
  end

  root to: "home#index"
end
