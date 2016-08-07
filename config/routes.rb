Rails.application.routes.draw do
  root to: 'servers#index'

  get '/servers/view' => 'servers#view'
  get '/user' => 'users#my_servers'
  get '/user/modify-password' => 'users#modify_password'
  get '/user/recover' => 'users#recover_password'
  get '/user/sign_in' => 'users#sign_in'

end
