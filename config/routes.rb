Rails.application.routes.draw do
  resources :notifications, except: [:update]
  resources :notification_contents, except: [:update]
  devise_for :users, path: 'users'
end