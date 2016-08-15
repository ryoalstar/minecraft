class ServersController < ApplicationController

  def index
    @servers = Server.paginate(:page => params[:page], :per_page => 15).order("votes DESC, players DESC")
    @serverCount = @servers.count
    @page = params[:page].to_i - 1
    if @page < 0
      @page = 0
    end
  end

  def new
    if current_user.nil?
      redirect_to '/users/sign_in'
    end
    @server = Server.new
  end

  def create
    if current_user.nil?
      redirect_to '/users/sign_in'
    end
    @server = Server.create(server_params.merge(:owner => current_user.username, :last_online => Time.now.to_i))
    redirect_to '/user/'
  end

  def view
    @server = Server.find(params[:id])
  end

  def vote
    @server = Server.find(params[:id])
    if verify_solvemedia_puzzle
      flash[:notice] = "Succesfully voted!"
    else
      flash[:error] = "Error, invalid voting captcha!"
    end

    redirect_to('/server/'+params[:id])

  end

  def edit
    if current_user.nil?
      redirect_to '/users/sign_in'
    end
    @server = Server.find(params[:id])
  end

  def save
    if current_user.nil?
      redirect_to '/users/sign_in'
    end
    @server = Server.find(params[:id])

    if @server.update_attributes(server_params)
      redirect_to '/server/' + params[:id] + "/edit"
      return
    else
      redirect_to '/server/' + params[:id] + "/edit"
    end
  end

  def destroy
    if current_user.nil?
      redirect_to '/users/sign_in'
    end
    @server = Server.find(params[:id])
    @server.destroy!
    redirect_to '/user/'
  end


  def server_params
    params.require(:server).permit(:name, :ip, :port, :description, :banner, :short_description)
  end
end
