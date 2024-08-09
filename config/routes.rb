Rails.application.routes.draw do
  devise_for :users
  root to: "home#index"
  
  namespace :admin do
    resources :projects
  end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
