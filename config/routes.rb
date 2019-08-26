Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'users#home'

  resources :users, only: [:index, :show, :new, :create]
  get '/home', to: 'users#home', as: 'home'
  get '/', to: 'users#home'
  get '/users/comparison/:id', to: 'users#comparison', as: 'comparison'
  get '/users/search/:id', to: 'users#search', as: 'user_search'

  ## movie routes
  resources :movies, only: [:index, :show]
  get '/search', to: 'movies#search', as: 'search'
  get '/usershow', to: 'movies#usershow', as: 'usershow'

  ## comparisons routes
  resources :comparisons, only: [:create, :index]

  ## favorites routes
  resources :favorites, only: [:index, :create, :destroy]
end
