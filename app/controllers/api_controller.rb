class ApiController < ApplicationController

  def check
    if params[:key].nil? or params[:id].nil? or params[:username].nil?
      render :nothing => true, :status => 400
    end

    @server = Server.find(params[:id])

    if @server.nil?
      render :nothing => true, :status => 404
    end

    unless @server.api_key.eql? params[:key]
      render :nothing => true, :status => 403
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
    if params[:key].nil? or params[:id].nil? or params[:username].nil?
      render :nothing => true, :status => 400
    end

    @server = Server.find(params[:id])

    if @server.nil?
      render :nothing => true, :status => 404
    end

    unless @server.api_key.eql? params[:key]
      render :nothing => true, :status => 403
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

