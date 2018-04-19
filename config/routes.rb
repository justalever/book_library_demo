require 'sidekiq/web'

Rails.application.routes.draw do
  resources :books
  devise_for :users, controllers: { registrations: "registrations" }
  root to: 'books#index'
  resources :pricing, only:[:index]
  resources :subscriptions
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
