Rails.application.routes.draw do
  devise_for :users, controllers:
    {registrations: "users/registrations",
      confirmations: "users/confirmations",
      sessions: "users/sessions",
      passwords: "users/passwords",
      unlocks: "users/unlocks",
      omniauth_callbacks: "users/omniauth_callbacks"}

  resources :users, only: %i(new create show) do
    resources :bookings do
      member do
        patch :cancel
      end
    end
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
    resources :reviews
  end
  root "static_pages#home"

  mount API::Base, at: "/"
end
