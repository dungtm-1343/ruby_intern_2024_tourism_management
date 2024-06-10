Rails.application.routes.draw do
  get "sessions/new"
  get "sessions/create"
  get "sessions/destroy"
  get "/login", to: "sessions#new"
  post "/login", to: "sessions#create"
  delete "/logout", to: "sessions#destroy"
  get "/signup", to: "users#new"
  post "/signup", to: "users#create"

  resources :users, only: %i(new create show) do
    resources :bookings
  end
  resources :account_activations, only: :edit


  get "/admin", to: "admin/tours#index"
  namespace :admin do
    resources :tours do
      member do
        #remove_image_admin_tour_path
        delete :remove_image
      end
    end
    resources :vouchers
    resources :bookings, only: %i(index show destroy update)
  end

  resources :tours, only: %i(index show) do
    resources :bookings
  end

  root "static_pages#home"
end
