Rails.application.routes.draw do
  
  devise_for :users
  resources :clients, only:[:index, :new, :create, :edit, :update, :destroy]
  resources :products, only:[:index, :new, :create, :edit, :update, :destroy]

  get 'clients/search' => 'clients#search', as: :search_clients
  get 'clients/:id' => 'clients#show'

  get 'products/search' => 'products#search', as: :search_products
  get 'products/cell' => 'products#cell'
  get 'products/eletronic' => 'products#eletronic'
  get 'products/part' => 'products#part'
  get 'products/accessory' => 'products#accessory'
  get 'products/:id' => 'products#show'

  root 'home#index'

  
end
