Rails.application.routes.draw do
  root to: "home#index"
  devise_for :admins
  resources :members
  resources :groups
  mount_devise_token_auth_for 'User', at: 'auth', controllers: {
    registrations:  'overrides/registrations'
  }
  resources :notifications, except: [:update]
  resources :notification_contents, except: [:update]
  resources :devices, only: [:update]
  resources :access
end