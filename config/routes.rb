Rails.application.routes.draw do
  root to: "home#index"
  devise_for :admins
  resources :groups do 
    member do 
      get :members
      delete :delete_member
      get :add_members
      post :add_member
      post :bulk_add
    end
  end
  mount_devise_token_auth_for 'User', at: 'auth', controllers: {
    registrations:  'overrides/registrations'
  }
  resources :notifications, except: [:update]
  resources :notification_contents, except: [:update]
  resources :devices, only: [:update]
  resources :access

  resources :user
end