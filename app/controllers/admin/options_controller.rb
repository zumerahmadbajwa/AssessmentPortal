# frozen_string_literal: true

module Admin
  # Options Controller
  class OptionsController < ApplicationController
    before_action :find_project
    before_action :find_assessment
    before_action :find_question
    before_action :find_option, only: %i[edit update destroy]

    def create
      @option = @question.options.build(option_params)
      if @option.save
        redirect_to(
          admin_project_assessment_path(@project, @assessment, @question),
          notice: 'Option was successfully created.'
        )
      else
        flash.now[:alert] = 'Error creating option.'
        render :new
      end
    end

    def update
      ensure_only_one_correct_option if option_params[:correct] == 'true' # Handle the 'correct' attribute carefully

      if @option.update(option_params)
        redirect_to(
          admin_project_assessment_path(@project, @assessment, @question),
          notice: 'Option was successfully updated.'
        )
      else
        render :edit
      end
    end

    def destroy
      @option.destroy
      redirect_to admin_project_assessment_questions_path(@question), notice: 'Option was successfully destroyed.'
    end

    private

    # Ensure only one option is correct by setting all other options to false
    def ensure_only_one_correct_option
      @question.options.where.not(id: @option.id).update_all(correct: false)
    end

    def find_project
      @project = Project.find(params[:project_id])
    end

    def find_assessment
      @assessment = Assessment.find(params[:assessment_id])
    end

    def find_question
      @question = Question.find(params[:question_id])
    end

    def find_option
      @option = @question.options.find(params[:id])
    end

    def option_params
      params.require(:option).permit(:content, :correct)
    end
  end
end
