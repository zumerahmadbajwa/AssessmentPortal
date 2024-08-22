class HomeController < ApplicationController
  before_action :authenticate_user!

  def index
    @assessment = Assessment.find_by(id: params[:id]) 
    @assessments = current_user.assessments
    puts @assessments.inspect
  end
end
