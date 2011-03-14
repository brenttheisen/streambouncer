class LogoutController < ApplicationController
  
  def index
    @logged_in_user = nil
  end
end
