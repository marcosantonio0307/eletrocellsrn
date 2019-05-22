Rails.application.routes.draw do
  
  devise_for :users
  resources :clients, only:[:index, :new, :create, :edit, :update, :destroy]
  resources :products, only:[:index, :new, :create, :edit, :update, :destroy]

  resources :sales do
  	resources :items
  end

  get 'clients/search' => 'clients#search', as: :search_clients
  get 'clients/:id' => 'clients#show'

  get 'products/search' => 'products#search', as: :search_products
  get 'products/cell' => 'products#cell'
  get 'products/eletronic' => 'products#eletronic'
  get 'products/part' => 'products#part'
  get 'products/accessory' => 'products#accessory'
  get 'products/:id' => 'products#show'

  get 'sales/:id/client' => 'sales#client', as: :client_sale
  post 'sales/:id/select' => 'sales#select', as: :select_sale

  post 'sales/:sale_id/items/:id' => 'items#add', as: :add_sale_item

  root 'home#index'

  
end
