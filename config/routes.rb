Rails.application.routes.draw do
  devise_for :users
  root to: "home#index"
  
  namespace :admin do
    resources :projects do
      resources :project_users, only: [:index, :create, :destroy]
      resources :assessments do 
        resources :results, only: [:index, :show, :destroy]
        resources :questions do
          resources :options, only: [:create, :update, :destroy]
        end    
      end
    end
  end

  resources :assessments, only: [:show] do
    member do
      get :attempt
      post :submit
      get :results
    end
  end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
