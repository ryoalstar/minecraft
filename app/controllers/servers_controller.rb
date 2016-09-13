class ServersController < ApplicationController

  def index

    @servers = Server.paginate(:page => params[:page], :per_page => 15).includes(:tags).order("votes DESC, players DESC")
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
    randomKey = ('a'..'z').to_a.shuffle[0,25].join
    @server = Server.new(server_params.merge(:owner => current_user.username, :last_online => Time.now.to_i, :api_key => randomKey))
    begin
      RestClient.get 'http://minecraftpingerapi.herokuapp.com/ping.php?ip='+@server.ip+"&port="+@server.port
    rescue
      flash[:error] = 'The server you are trying to add is not currently online or we are not able to reach it.'
      redirect_to '/server/new' and return
    end
    @server.save
    redirect_to '/user/'
  end

  def view
    @server = Server.find(params[:id])
  end

  def vote
    @server = Server.find(params[:id])

    if verify_recaptcha

      vote = Vote.where("server = ? AND ip = ? AND time > UNIX_TIMESTAMP() - 43200", @server.id, request.remote_ip)

      unless vote.nil?
        flash[:error] = "You have already voted for this server within the last 12 hours!"
        redirect_to('/server/'+params[:id]) and return
      end

      flash[:notice] = "You have succesfully voted for " + @server.name
      @server.votes += 1
      @server.save

      @vote = Vote.new(:ip => request.remote_ip, :username => params[:server][:username], :server => @server.id, :time => Time.now.to_i)
      @vote.save
    else
      flash[:error] = "The captcha could not be verified."
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
    begin
      RestClient.get 'http://minecraftpingerapi.herokuapp.com/ping.php?ip='+@server.ip+"&port="+@server.port
    rescue
      flash[:error] = 'The server you are trying to add is not currently online or we are not able to reach it.'
      redirect_to '/server/new' and return
    end
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
