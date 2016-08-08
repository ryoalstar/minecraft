Rails.application.routes.draw do
  devise_for :users
  resource :users

  root to: 'servers#index'

  get '/servers/view' => 'servers#view'
  get '/user' => 'users#my_servers'

end
