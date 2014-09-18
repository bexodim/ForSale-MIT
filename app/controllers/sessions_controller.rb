class SessionsController < ApplicationController
  ##         handles login and logout          ##
  ## session lasts until the browser is exited ##
  
  # GET /login
  def new
	if session[:user_id]
		redirect_to user_path(current_user)
	end
  end

  #POST /sessions
  def create
	u = User.authenticate(params[:kerberos],params[:password])
	if u
		session[:user_id] = u.id
		redirect_to user_path(u), :notice => "You have successfully logged in with your Athena account."
	else
		flash.now.alert = "Invalid kerberos login."
		render "new"
	end
  end
  
  # GET /logout
  def destroy
	session[:user_id] = nil
	redirect_to root_url, :notice => "You have successfully logged out of your acount."
  end
end
