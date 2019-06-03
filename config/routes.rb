Rails.application.routes.draw do
  
  devise_for :users
  resources :clients, only:[:index, :new, :create, :edit, :update, :destroy]
  resources :products, only:[:index, :new, :create, :edit, :update, :destroy]
  resources :expenses, only:[:index, :new, :create, :edit, :update, :destroy]

  get 'sales/filter_date' => 'sales#filter_date'
  get 'sales/sales' => 'sales#sales'
  get 'sales/search' => 'sales#search'
  get 'sales/salesman' => 'sales#salesman'
  get 'sales/report_salesman' => 'sales#report_salesman'
  get 'sales/commission' => 'sales#commission'
  get 'sales/report_commission' => 'sales#report_commission'
  get 'sales/sales_day' => 'sales#sales_day'
  get 'sales/services_day' => 'sales#services_day'
  get 'sales/new_service' => 'sales#new_service', as: :new_service_sale
  get 'sales/services' => 'sales#services'
  get 'sales/:id/finish' => 'sales#finish', as: :finish_sale
  get 'sales/opens' => 'sales#opens'

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
  get 'products/category' => 'products#category'
  get 'products/report_products' => 'products#report_products'
  get 'products/cost' => 'products#cost'
  get 'products/:id/add' => 'products#add', as: :add_product
  get 'products/:id/entry' => 'products#entry', as: :entry_product
  get 'products/:id' => 'products#show'

  get 'sales/:id/client' => 'sales#client', as: :client_sale
  post 'sales/:id/select' => 'sales#select', as: :select_sale


  post 'sales/:sale_id/items/:id' => 'items#add', as: :add_sale_item

  get 'expenses/advance' => 'expenses#advance', as: :advance_expense
  get 'expenses/devolution' => 'expenses#devolution', as: :devolution_expense
  get 'expenses/expenses' => 'expenses#expenses'
  get 'expenses/advances' => 'expenses#advances'
  get 'expenses/devolutions' => 'expenses#devolutions'
  get 'expenses/filter_date' => 'expenses#filter_date'
  get 'expenses/expenses_day' => 'expenses#expenses_day'
  get 'expenses/:id' => 'expenses#show'

  root 'home#index'

  
end
