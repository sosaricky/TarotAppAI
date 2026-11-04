Rails.application.routes.draw do
devise_for :users, controllers: { registrations: "users/registrations", passwords: "users/passwords" }

  authenticated :user do
    root to: "dashboard#index", as: :authenticated_root
  end

  unauthenticated do
    root to: "home#index"
  end

  resources :readings, only: [:index, :show, :create] do
    post :anonymous, on: :collection
  end

  get "/dashboard", to: "dashboard#index"

  get "up" => "rails/health#show", as: :rails_health_check
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
end
