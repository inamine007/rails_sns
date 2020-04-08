Rails.application.routes.draw do
  root to: 'users#top'
  resources :users do
    get :users, action: :top
  end
end
