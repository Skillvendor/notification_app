Rails.application.routes.draw do
  resources :members
  resources :groups
  mount_devise_token_auth_for 'User', at: 'auth', controllers: {
    registrations:  'overrides/registrations'
  }
  resources :notifications, except: [:update]
  resources :notification_contents, except: [:update]
  resources :devices, only: [:update]
end