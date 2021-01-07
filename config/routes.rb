Rails.application.routes.draw do
  devise_for :users
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  root 'items#index'

  resources :items do
    collection do
      get :add
    end

    member do
      get :toggle_like
    end

    resources :comments
  
	end
  resources :orders do
    resources :line_items
	end
  
end
