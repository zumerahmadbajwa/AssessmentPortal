# frozen_string_literal: true

module Admin
  # Questions Controller
  class QuestionsController < ApplicationController
    before_action :find_project
    before_action :find_assessment
    before_action :find_question, only: %i[show edit update destroy]

    def index
      @questions = @assessment.questions
    end

    def new
      @question = @assessment.questions.build
      4.times { @question.options.build }
    end

    def create
      @assessment = @project.assessments.find(params[:assessment_id])
      @question = @assessment.questions.build(question_params)
      if @question.save
        redirect_to admin_project_assessment_path(@project, @assessment), notice: 'Question was successfully created.'
      else
        render :new
      end
    end

    # Load the question and its options
    def edit
      @options = @question.options
    end

    def show; end

    # Handle the update logic for both the question and its options
    def update
      if @question.update(question_params)
        redirect_to(
          admin_project_assessment_question_path(@project, @assessment, @question),
          notice: 'Question and options updated successfully.'
        )
      else
        render :edit
      end
    end

    def destroy
      @question.destroy
      redirect_to admin_project_assessments_path(@assessment), notice: 'Question was successfully destroyed.'
    end

    private

    def find_project
      @project = Project.find(params[:project_id])
    rescue ActiveRecord::RecordNotFound
      redirect_to admin_projects_path, alert: 'Project not found.'
    end

    def find_assessment
      @assessment = Assessment.find(params[:assessment_id])
    rescue ActiveRecord::RecordNotFound
      redirect_to admin_project_path(@project), alert: 'Assessment not found.'
    end

    def find_question
      @question = @assessment.questions.find(params[:id])
    end

    def question_params
      params.require(:question).permit(
        :content,
        :assessment_id,
        options_attributes: %i[id content correct _destroy]
      )
    end
  end
end
