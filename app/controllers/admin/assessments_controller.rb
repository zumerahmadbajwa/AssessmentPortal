# frozen_string_literal: true

module Admin
  # Assessment Controller
  class AssessmentsController < ApplicationController
    before_action :find_project
    before_action :find_assessment, only: %i[show edit update destroy]

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
        assign_users if params[:assessment][:user_ids].present?
        redirect_to admin_project_assessment_path(@project, @assessment), notice: 'Assessment was successfully created.'
      else
        render :new
      end
    end

    def edit; end

    def update
      # Assign selected users to the assessment and handle the many-to many relationship
      @assessment.user_ids = params[:assessment][:user_ids]

      if @assessment.update(assessment_params)
        redirect_to admin_project_assessment_path(@project, @assessment), notice: 'Assessment was successfully updated.'
      else
        render :edit
      end
    end

    def destroy
      if @assessment.destroy
        redirect_to admin_project_assessments_path(@project), notice: 'Assessment was successfully deleted.'
      else
        redirect_to admin_project_assessments_path(@project), alert: 'Failed to delete the assessment.'
      end
    end

    def delete_modal
      @assessment = @project.assessments.find(params[:assessment_id])
    end

    private

    def assign_users
      user_ids = params[:assessment][:user_ids].map(&:to_i) # Ensure IDs are integers
      additional_users = User.where(id: user_ids)
      
      # Add users that are not already associated
      additional_users.each do |user|
        @assessment.users << user unless @assessment.users.include?(user)
      end
    end

    def find_project
      @project = Project.find(params[:project_id])
    end

    def find_assessment
      @assessment = @project.assessments.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      redirect_to admin_project_path(@project), alert: 'Assessment not found.'
    end

    def assessment_params
      params.require(:assessment).permit(
        :title,
        :description,
        user_ids: [],
        questions_attributes: %i[id content _destroy]
      )
    end
  end
end
