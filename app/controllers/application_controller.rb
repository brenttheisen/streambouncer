class ApplicationController < ActionController::Base
  
  protect_from_forgery
  
  before_filter :ensure_domain
  before_filter :get_user_from_session
  before_filter :get_user_from_cookie
  after_filter :set_user_on_session

  APP_DOMAIN = 'streambouncer.com'

  def ensure_domain
    if ::Rails.env == 'production' && request.env['HTTP_HOST'] != APP_DOMAIN
      # HTTP 301 is a "permanent" redirect
      redirect_to "http://#{APP_DOMAIN}", :status => 301
    end
  end
  
  def host_port_name
    self.request.port == 80 ? self.request.host : "#{self.request.host}:#{self.request.port}"
  end
  
  private
  
  def get_user_from_session
    @logged_in_user = session[:logged_in_user] unless session[:logged_in_user].nil?
    @logged_in_user.reload unless @logged_in_user.nil?
  end
  
  def get_user_from_cookie
    return unless @logged_in_user.nil? || cookies[:u].nil?
      
    @logged_in_user = User.where(:cookie => cookies[:u]).first
  end
  
  def set_user_on_session
    session[:logged_in_user] = @logged_in_user
    cookies[:u] = @logged_in_user.nil? ? nil : { :value => @logged_in_user.cookie, :expires => Time.now + 60 * 60 * 24 * 365 }
  end
end
