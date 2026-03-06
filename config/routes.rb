Rails.application.routes.draw do
  require "sidekiq/web"

  devise_for :users, path: "admin", path_names: {
    sign_in: "login",
    sign_out: "logout",
    password: "password",
    registration: "register"
  }
  root "dashboard/home#index"

  namespace :admin do
    root "dashboard#index"
    resource :push_subscription, only: %i[create destroy]
    resource :profile, only: %i[show edit update]
    resources :reader_zones, only: %i[index show], path: "zonas"
    resources :readings, only: %i[index new create edit update]
    resources :invoices, only: %i[index create edit update] do
      member do
        get :pdf
      end
    end
    resources :payments, only: %i[index create update]
    resources :users, only: %i[index new create edit update] do
      member do
        patch :update_assignment
      end
    end
    resources :zones, only: %i[index create update]
    resources :categories, only: %i[index create update]
    resources :meters, only: %i[index new create update destroy]
  end

  authenticate :user, ->(user) { user.admin? } do
    mount Sidekiq::Web => "/sidekiq"
  end

  namespace :api do
    namespace :v1 do
      resources :readings, only: %i[create update]
      resources :invoices, only: %i[create] do
        member do
          get :pdf
        end
      end
      resources :payments, only: %i[create]
      resources :users, only: [] do
        member do
          patch :assign_zone
          patch :assign_category
        end
      end
      post "meetings/notify", to: "meetings#notify"
    end
  end

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest

  # Defines the root path route ("/")
  # root "posts#index"
end
