class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController

  def facebook
    # You need to implement the method below in your model (e.g. app/models/user.rb)
    @user = User.from_omniauth(request.env["omniauth.auth"])

    if @user.persisted?
      sign_in_and_redirect @user, :event => :authentication #this will throw if @user is not activated
      set_flash_message(:notice, :success, :kind => "Facebook") if is_navigational_format?
    else
      session["devise.facebook_data"] = request.env["omniauth.auth"]
      sign_in_and_redirect @user, :event => :authentication #this will throw if @user is not activated
    end
  end

  def google_oauth2
    # You need to implement the method below in your model (e.g. app/models/user.rb)
    @user = User.from_omniauth(request.env["omniauth.auth"])

    if @user.persisted?
      flash[:notice] = I18n.t "devise.omniauth_callbacks.success", :kind => "Google"
      sign_in_and_redirect @user, :event => :authentication
    else
      session["devise.google_data"] = request.env["omniauth.auth"]
      sign_in_and_redirect @user, :event => :authentication #this will throw if @user is not activated
    end
  end

  def self.from_omniauth(access_token)
    data = access_token.info
    user = User.where(:email => data["email"]).first

     unless user
       if user and user.confirmed?
         user.provider = auth.provider
         user.uid = auth.uid
         return user
       end
       where(auth.slice(:provider, :uid)).first_or_create do |user|
         user.skip_confirmation!
         user.provider = auth.provider
         user.uid = auth.uid
         user.email = auth.info.email
         user.password = Devise.friendly_token[0,20]
       end
     end
  end

  def failure
    redirect_to root_path
  end
end