BillIt::Application.routes.draw do

  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)

  root :to => "bills#index"


  namespace :cl do
    resources :bills do
      get 'feed', on: :member
      get 'search', on: :collection
      get 'last_update', on: :collection
    end
    resources :paperworks do
      get 'search', on: :collection
    end
  end

  resources :bills do
  	get 'feed', on: :member
  	get 'search', on: :collection
  	get 'last_update', on: :collection
  end
end