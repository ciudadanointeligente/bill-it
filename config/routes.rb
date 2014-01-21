BillIt::Application.routes.draw do
  resources :paperworks do
    get 'search', on: :collection
  end

  resources :bills do
  	get 'feed', on: :member
  	get 'search', on: :collection
  	get 'last_update', on: :collection
  end
end