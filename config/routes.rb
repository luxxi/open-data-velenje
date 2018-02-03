Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :organizations, only: :show
    end
  end
  resource :organizations, only: :update
end
