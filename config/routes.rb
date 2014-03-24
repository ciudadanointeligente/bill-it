BillIt::Application.routes.draw do

  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)

  root :to => "bills#index"

  resources :paperworks do
    get 'search', on: :collection
  end

  resources :bills do
  	get 'feed', on: :member
  	get 'search', on: :collection
  	get 'last_update', on: :collection
  end
end