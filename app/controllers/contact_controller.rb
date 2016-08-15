class ContactController < ApplicationController

  def new

  end

  def submit
    name = params[:name]
    email = params[:email]
    comments = params[:comments]
    Mail.deliver do
      to 'Support@minecraft-pe-servers.com'
      from email
      subject '['+name+' filled in the contact form on the website]'
      body comments
    end
    flash[:notice] = "Succesfully sent! We'll get back to you within 24H.";
    redirect_to '/contact'
  end
end
