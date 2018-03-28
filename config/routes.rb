Rails.application.routes.draw do
  devise_for :organizations, controllers: { registrations: "registrations" }

  namespace :api do
    namespace :v1 do
      resources :organizations, only: :show
    end
  end

  resources :organizations, except: [:edit, :new, :create, :destroy] do
    get 'set_api'
  end

  authenticated :organization do
      root 'home#index', as: :authenticated_root
  end

  root to: "home#landing"

  get 'organizations', to: 'home#index'
  get 'api', to: 'home#api'
  get 'approvement_notice', to: 'home#approvement_notice'
  get 'organicity', to: 'home#organicity'
  get 'share', to: 'home#share'
  get 'join', to: 'home#join'

end
