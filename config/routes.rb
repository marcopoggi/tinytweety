Rails.application.routes.draw do
  devise_for :users
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  root 'main#index'
  get '/home', to: 'main#index'

  scope module: 'authenticate' do
    get '/notifications', to: 'notifications#index'
    get '/explore', to: 'search#index'
    get '/messages', to: 'messages#index'
  end
end
