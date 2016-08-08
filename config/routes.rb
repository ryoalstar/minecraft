Rails.application.routes.draw do
  devise_for :users
  resource :users

  root to: 'servers#index'

  get '/faq' => 'static#faq'
  get '/about' => 'static#about'

  get '/server/:id/' => 'servers#view'
  post '/server/:id/' => 'servers#vote'
  get '/user' => 'users#my_servers'

end
