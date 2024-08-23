module Admin
  # Results Controller
  class ResultsController < ApplicationController
    before_action :authenticate_user!
    before_action :find_result, only: [:destroy]
    before_action :set_project_and_assessment
    
    def index
      @assessment = Assessment.find(params[:assessment_id])
      @results = @assessment.results.includes(:user_answers)
    end

    def show
      @result = @assessment.results.find(params[:id])
    end

    def destroy
      @result.destroy
      redirect_to admin_project_assessment_results_path(@project, @assessment, @result), notice: 'Result was successfully destroyed.'
    end
    
    private

    def set_project_and_assessment
      @project = Project.find(params[:project_id])
      @assessment = @project.assessments.find(params[:assessment_id])
    end

    def find_result
      @project = Project.find(params[:project_id])
      @assessment = @project.assessments.find(params[:assessment_id])
      @result = @assessment.results.find_by(id: params[:id])
    end
  end
end
