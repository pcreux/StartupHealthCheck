class Auth0Controller < ApplicationController
  def callback
    session[:userinfo] = env['omniauth.auth']
    redirect_to set_session_path
  end
end
