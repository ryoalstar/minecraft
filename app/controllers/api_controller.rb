class ApiController < ApplicationController

  def check
    if params[:key].nil? or params[:username].nil?
      render :nothing => true, :status => 400
    end

    @server = Server.where("api_key = ?", params[:key]).first

    if @server.nil?
      render :nothing => true, :status => 404
    end

    vote = Vote.where("server = ? AND username = ? UNIX_TIMESTAMP() - time < 43200", @server.id, params[:username])

    if vote.nil?
      respond_to do |format|
        format.html { render :text => "0" }
      end
    end
    respond_to do |format|
      format.json { render :text => (vote.claimed == 1 ? 2 : 1) }
    end

  end

  def claim
    if params[:key].nil? or params[:username].nil?
      render :nothing => true, :status => 400
    end

    @server = Server.where("api_key = ?", params[:key]).first

    if @server.nil?
      render :nothing => true, :status => 404
    end

    vote = Vote.where("server = ? AND username = ? UNIX_TIMESTAMP() - time < 43200", @server.id, params[:username])

    if vote.nil?
      respond_to do |format|
        format.html { render :text => "0" }
      end
    end

    vote.claimed = 1
    vote.save
    if vote.nil?
      respond_to do |format|
        format.html { render :text => "1" }
      end
    end
  end
end

