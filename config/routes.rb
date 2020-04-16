Rails.application.routes.draw do
  resources :posts do
    resources :comments, only: [:create, :destroy]
    resources :likes, only: [:create, :destroy]
  end
  resources :relationships, only: [:create, :destroy, :index]
  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'
  root to: 'users#top'
  resources :users do
    member do
      get 'mypage'
      get 'following'
      get 'followers'
    end
  end
  
end
