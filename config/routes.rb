Rails.application.routes.draw do
  devise_for :users
  root to: "home#index"
  
  namespace :admin do
    resources :projects do
      resources :project_users, only: [:index, :create, :destroy]
      resources :assessments do 
        resources :results, only: [:index, :show]
      end
    end
  end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
