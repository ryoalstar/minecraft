Rails.application.routes.draw do
  devise_for :users

  resource :users

  root to: 'servers#index'

  post '/' => 'servers#search_redirect'

  get '/search/:search/' => 'servers#search'

  get '/servers/list/:page' => "servers#index"
  get '/version/:version' => 'servers#version'
  get '/version/:version/:page' => 'servers#version'

  get '/servers/:type' => 'servers#type'
  get '/servers/:type/:page' => 'servers#type'

  get '/faq' => 'faq#index'
  get '/contact' => 'contact#new'
  post '/contact' => 'contact#submit'
  get '/privacy-policy' => 'static#privacy_policy'
  get '/about' => 'static#about'
  get '/terms' => 'static#terms_of_service'
  get '/server/new' => 'servers#new'
  post '/server/new' => 'servers#create'
  patch '/server/:id/vote' => 'servers#vote'
  get '/server/:id/' => 'servers#view'
  get '/server/:id/edit' => 'servers#edit'
  patch '/server/:id/edit' => 'servers#save'
  get '/server/:id/destroy' => 'servers#destroy'

  get '/user' => 'users#my_servers'

  get 'api' => 'static#api'
  get '/api/votes/claim' => 'api#check'
  post '/api/votes/claim' => 'api#claim'
end
