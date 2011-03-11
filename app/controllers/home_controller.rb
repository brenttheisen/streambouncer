class HomeController < ApplicationController
  
  def index
    render :action => 'index_not_logged_in' if @logged_in_user.nil?
  end
end
