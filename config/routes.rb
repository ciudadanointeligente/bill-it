BillIt::Application.routes.draw do
  match 'bills/search' => 'bills#search'
  resources :bills
end