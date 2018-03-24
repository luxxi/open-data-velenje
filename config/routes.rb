Rails.application.routes.draw do
  devise_for :organizations, controllers: { registrations: "registrations" }

  require 'sidekiq/web'
  mount Sidekiq::Web => '/sidekiq'

  namespace :api do
    namespace :v1 do
      resources :organizations, only: :show
    end
  end

  resources :organizations, except: [:edit, :new, :create, :destroy] do
    get 'set_api'
  end

  get 'approvement_notice', to: 'home#approvement_notice'

  authenticated :organization do
      root 'home#index', as: :authenticated_root
  end

  root to: "home#landing"

  get 'organizations', to: 'home#index'

  get 'api', to: 'home#api'
end
