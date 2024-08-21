# Assessment Controller
class AssessmentsController < ApplicationController
  before_action :authenticate_user!
  before_action :find_assessment, only: [:show, :attempt, :submit, :results]
  
  def show
    @questions = @assessment.questions.includes(:options)
  end

  def attempt
    authorize @assessment
    @questions = @assessment.questions.includes(:options)
    @assessments = current_user.assessments.find(params[:id])
  end

  def submit
    user_answers = permitted_params[:answers] || {}

    serialized_answers = user_answers.to_json # Serialize answers to JSON

    @score = calculate_score(user_answers)

    redirect_to results_assessment_path(@assessment, score: @score, answers: serialized_answers)
  end

  def results
    @score = params[:score].to_i
    @answers = JSON.parse(params[:answers] || '{}') 
  end

  private

  def find_assessment
    @assessment = Assessment.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    flash[:alert] = 'Assessment not found.'
    redirect_to assessments_path
  end

  def permitted_params
    params.permit(:id, answers: {})
  end

  def calculate_score(answers)
    correct_answers = 0

    @assessment.questions.each do |question|
      selected_option_id = answers[question.id.to_s]
      correct_option = question.options.find_by(correct: true)

      if correct_option && selected_option_id.to_i == correct_option.id
        correct_answers += 1
      end
    end

    correct_answers * 10
  end
end
