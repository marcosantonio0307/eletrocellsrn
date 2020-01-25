Rails.application.routes.draw do
  
  devise_for :users
  resources :clients, only:[:index, :new, :create, :edit, :update, :destroy]
  resources :products, only:[:index, :new, :create, :edit, :update, :destroy]
  resources :expenses, only:[:index, :new, :create, :edit, :update, :destroy]
  resources :cash, only:[:index, :new, :edit, :update]

  get 'users/edit_user' => 'users#edit_user'
  get 'users/edit_category/:id' => 'users#edit_category', as: :category_user
  resources :users, only:[:index, :new, :create, :edit, :update]


  get 'cash/report' => 'cash/report'
  get 'cash/filter_date' => 'cash#filter_date'
  get 'cash/reopen' => 'cash#reopen'
  get 'cash/:id' => 'cash#show'

  get 'sales/filter_date' => 'sales#filter_date'
  get 'sales/sales' => 'sales#sales'
  get 'sales/:id/print' => 'sales#print', as: :print_sale
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
  get 'sales/:id/search_item' => 'sales#search_item', as: :search_item_sale
  get 'sales/:sale_id/new_select/:id' => 'items#new_select', as: :new_select_sale_item
  get 'sales/:sale_id/select_client/:id' => 'sales#select_client', as: :select_client_sale
  get 'sales/:id/cancel' => 'sales#cancel', as: :cancel_sale
  get 'sales/opens' => 'sales#opens'
  resources :sales do
  	resources :items
  end

  get 'clients/:id' => 'clients#show'

  get 'products/search' => 'products#search', as: :search_products
  get 'products/category' => 'products#category'
  get 'products/report_products' => 'products#report_products'
  get 'products/inventory' => 'products#inventory'
  get 'products/cost' => 'products#cost'
  get 'products/:id/add' => 'products#add', as: :add_product
  get 'products/:id/entry' => 'products#entry', as: :entry_product
  get 'products/:id' => 'products#show'

  get 'sales/:id/client' => 'sales#client', as: :client_sale
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
