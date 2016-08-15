class UsersController < ApplicationController

  before_action :authenticate_user!

  def index
    @users = User.all
  end

  def show
    @user = current_user
  end

  def sign_in

  end

  def my_servers
    @servers = Server.where("owner = ?", current_user.username)
  end

  def modify_password
    @user = current_user
  end

  def recover_password

  end
end
