Rails.application.routes.draw do
  get 'messages/index'
  get 'search/index'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  # Defines the root path route ("/")
  # root "articles#index"
  root 'main#index'

  get '/home', to: 'main#index'
  get '/notifications', to: 'notifications#index'
  get '/explore', to: 'search#index'
  get '/messages', to: 'messages#index'
end
