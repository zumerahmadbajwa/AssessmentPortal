module Admin
  # Assessment Controller
  class AssessmentsController < ApplicationController
    before_action :find_project
    before_action :find_assessment, only: [:show, :edit, :update, :destroy]

    def index
      @assessments = @project.assessments
    end

    def show; end

    def new
      @assessment = @project.assessments.new
      @assessment.questions.build
    end

    def create
      @assessment = @project.assessments.new(assessment_params)
      if @assessment.save
        if params[:assessment][:user_ids]
          additional_users = User.where(id: params[:assessment][:user_ids])
          @assessment.users << additional_users
        end
        redirect_to admin_project_assessment_path(@project, @assessment), notice: 'Assessment was successfully created.'
      else
        render :new
      end
    end

    def edit; end

    def update
      # Assign selected users to the assessment
      @assessment.user_ids = params[:assessment][:user_ids]

      if @assessment.update(assessment_params)
        redirect_to admin_project_assessment_path(@project, @assessment), notice: 'Assessment was successfully updated.'
      else
        render :edit
      end
    end

    def destroy
      @assessment.destroy
      redirect_to admin_project_assessments_path(@project), notice: 'Assessment was successfully deleted.'
    end

    private

    def find_project
      @project = Project.find(params[:project_id])
    end

    def find_assessment
      @assessment = @project.assessments.find(params[:id])
      rescue ActiveRecord::RecordNotFound
        redirect_to admin_project_path(@project), alert: 'Assessment not found.'
    end

    def assessment_params
      params.require(:assessment).permit(:title, :description, user_ids: [], questions_attributes: [:id, :content, :_destroy])
    end
  end
end
