BillIt::Application.routes.draw do
  match 'bills/search' => 'bills#search'
  match 'bills/last_update' => 'bills#last_update'
  resources :bills
end