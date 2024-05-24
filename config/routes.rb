Rails.application.routes.draw do
  get "sessions/new"
  get "sessions/create"
  get "sessions/destroy"
  get "/login", to: "sessions#new"
  post "/login", to: "sessions#create"
  delete "/logout", to: "sessions#destroy"
  get "/signup", to: "users#new"
  post "/signup", to: "users#create"

  resources :users, only: %i(new create show)
  resources :account_activations, only: :edit

  get "/admin", to: "admin/tours#index"
  namespace :admin do
    resources :tours
  end

  root "static_pages#home"

  resources :tours, only: :index
end
