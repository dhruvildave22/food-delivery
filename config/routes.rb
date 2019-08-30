# frozen_string_literal: true

Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :restaurants, only: %i[index show create update]
  get '/users', to: 'users#role_index'
  resources :users, only: %i[show create update]
  post 'login' => 'sessions#login'
  delete 'logout' => 'sessions#logout'
  put '/forgot_password', to: 'sessions#forgot_password'
  put '/users/:reset_password_token/reset_password', to: 'users#reset_password'
end
