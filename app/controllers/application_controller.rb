class ApplicationController < ActionController::Base
  protect_from_forgery
  
  before_filter :set_user_controller
  after_filter :set_user_session
  
  def host_port_name
    self.request.port == 80 ? self.request.host : "#{self.request.host}:#{self.request.port}"
  end
  
  private
  
  def set_user_controller
    @logged_in_user = session[:logged_in_user] unless session[:logged_in_user].nil?
  end
  
  def set_user_session
    session[:logged_in_user] = @logged_in_user
  end
end
