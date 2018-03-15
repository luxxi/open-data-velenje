Rails.application.routes.draw do
  devise_for :organizations, controllers: { registrations: "registrations" }

  require 'sidekiq/web'
  mount Sidekiq::Web => '/sidekiq'

  namespace :api do
    namespace :v1 do
      resources :organizations, only: :show
    end
  end

  resources :organizations, except: [:index, :edit, :show, :new, :create, :destroy] do
    get 'set_api'
  end

  get 'approvement_notice', to: 'home#approvement_notice'

  root to: "home#index"
end
