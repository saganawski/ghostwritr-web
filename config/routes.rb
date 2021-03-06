Rails.application.routes.draw do

  root 'posts#index'
  get '/shakespeare' => 'home#shakespeare'
  get '/rowling' => 'home#rowling'
  get '/got' => 'home#got'

  resources :posts do 
  	resources :votes, only:[:create]
  	resources :comments, only: [:new, :create, :destroy] 
  end

# TODO remove index routes
  resources :comments, only: [:index] do 
  	resources :votes, only:[:create]
  end

  resources :users, only: [:new, :create, :show] 
  resources :sessions, only: [:new, :create, :destroy]
end
