Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  devise_for :users
  root 'main#index'
  get '/home', to: 'main#index'

  devise_scope :user do
    authenticated :user do
      scope module: 'authenticate' do
        get '/notifications', to: 'notifications#index'
        get '/explore', to: 'search#index'
        get '/messages', to: 'messages#index'
      end
    end
  end
end
