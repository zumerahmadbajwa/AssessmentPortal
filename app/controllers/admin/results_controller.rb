module Admin
  # Results Controller
  class ResultsController < ApplicationController
    before_action :set_assessment

    def index
      @results = @assessment.results.includes(:user)  # Assuming you have a results association
    end

    def show
      @result = @assessment.results.find(params[:id])  # Fetch a specific result
    end

    private

    def set_assessment
      @assessment = Assessment.find(params[:assessment_id])
    end
  end
end
