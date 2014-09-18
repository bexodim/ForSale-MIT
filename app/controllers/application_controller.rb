class ApplicationController < ActionController::Base
  helper_method :current_user, :current_room, :current_bag
  
  ## user who is currently logged in ##
  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id] #if current_user is nil then replace it, if there is a current session
  end
  
  ## room of user who is currently logged in ##
  def current_room
	@current_room ||= Room.where(:user_id => session[:user_id]).first if session[:user_id] #if current_user is nil then replace it, if there is a current session
  end
  
  ## bag of user who is currently logged in ##
  def current_bag
	@current_bag ||= Bag.where(:user_id => session[:user_id]).first if session[:user_id] #if current_user is nil then replace it, if there is a current session
  end
  
  ## redirect to previous page ##
  def redirect_to_stored
    if return_to = session[:return_to]
      session[:return_to] = nil
      redirect_to_url(return_to)
    else
      redirect_to :action=>'show'
    end
  end
end
