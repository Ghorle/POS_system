Rails.application.routes.draw do
  resources :order_products, only: [], param: :index do
    member do
      delete '(:id)' => "order_products#destroy", as: ""
      post '/' => "order_products#create"
      get '/:id' => "order_products#show"
    end
  end

  resources :orders do
    collection do
      get "closed"
    end
    get "products", on: :member
    get "mark_closed", on: :member
    get "mark_ready", on: :member
  end
  resources :order_products, only: [:show]
  resources :addons
  resources :products
  root 'home#index'
  devise_for :users
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
