Rails.application.routes.draw do
  devise_for :users
  resource :users

  root to: 'servers#index'


  get '/faq' => 'faq#index'
  get '/contact' => 'contact#new'
  post '/contact' => 'contact#submit'
  get '/about' => 'static#about'

  get '/server/new' => 'servers#new'
  post '/server/new' => 'servers#create'
  get '/server/:id/' => 'servers#view'
  get '/server/:id/edit' => 'servers#edit'
  patch '/server/:id/edit' => 'servers#save'
  get '/server/:id/destroy' => 'servers#destroy'
  post '/server/:id/' => 'servers#vote'

  get '/user' => 'users#my_servers'

end
