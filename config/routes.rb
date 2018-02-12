Rails.application.routes.draw do
  devise_for :organizations
  namespace :api do
    namespace :v1 do
      resources :organizations, only: :show
    end
  end
  resource :organizations, only: :update

  root to: "home#index"
end
