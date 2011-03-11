class ApplicationController < ActionController::Base
  protect_from_forgery
  
  before_filter :set_user_controller
  after_filter :set_user_session
  
  private
  
  def set_user_controller
    @logged_in_user = session[:logged_in_user] unless session[:logged_in_user].nil?
  end
  
  def set_user_session
    session[:logged_in_user] = @logged_in_user unless @logged_in_user.nil?
  end
end
