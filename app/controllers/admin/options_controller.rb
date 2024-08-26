# frozen_string_literal: true

module Admin
  # Options Controller
  class OptionsController < ApplicationController
    before_action :find_question
    before_action :find_option, only: %i[edit update destroy]

    def create
      @option = @question.options.build(option_params)
      if @option.save
        redirect_to edit_admin_question_path(@question), notice: 'Option was successfully created.'
      else
        render :edit
      end
    end

    def update
      # Handle the 'correct' attribute carefully
      if option_params[:correct] == 'true'
        # Ensure only one option is correct by setting all other options to false
        @question.options.where.not(id: @option.id).update_all(correct: false)
      end

      if @option.update(option_params)
        redirect_to edit_admin_question_path(@question), notice: 'Option was successfully updated.'
      else
        render :edit
      end
    end

    def destroy
      @option.destroy
      redirect_to edit_admin_question_path(@question), notice: 'Option was successfully destroyed.'
    end

    private

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
