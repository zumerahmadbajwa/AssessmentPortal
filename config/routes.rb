# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users
  root to: 'home#index'
  namespace :admin do
    resources :projects do
      resources :project_users, only: %i[index create destroy]
      resources :assessments do
        resources :results, only: %i[index show destroy]
        resources :questions do
          resources :options, only: %i[create update destroy]
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
