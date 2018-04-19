require 'sidekiq/web'

Rails.application.routes.draw do

  resources :books do
    member do
      put "add", to: "books#library"
      put "remove", to: "books#library"
    end
  end

  devise_for :users, controllers: { registrations: "registrations" }
  root to: 'books#index'
  resources :pricing, only:[:index]
  resources :subscriptions
end
