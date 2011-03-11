class LogoutController < ApplicationController
  
  def index
    @logged_in_user = nil
    redirect_to :controller => :home
  end
end
