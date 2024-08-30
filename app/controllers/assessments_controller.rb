# frozen_string_literal: true

# Assessment Controller
class AssessmentsController < ApplicationController
  before_action :authenticate_user!
  before_action :find_assessment, only: %i[show attempt submit results]

  def show
    @questions = @assessment.questions.includes(:options)
  end

  def attempt
    authorize @assessment
    @questions = @assessment.questions.includes(:options)
    @assessments = current_user.assessments.find(params[:id])
  end

  def submit
    user_answers = permitted_params[:answers].to_unsafe_h || {}
    @result = create_result

    if @result.persisted?
      save_user_answers(user_answers)
      update_result(user_answers)
      redirect_to results_assessment_path(@assessment, score: @score)
    else
      redirect_to attempt_assessment_path(@assessment)
    end
  end

  def results
    @score = params[:score].to_i
    @user_answers = UserAnswer.where(user: current_user, assessment: @assessment)
    @questions = @assessment.questions.includes(:options)
  end

  private

  # Create a result record for storing user answers
  def create_result
    Result.create(user: current_user, assessment: @assessment)
  end

  # Iterate over the answers and save them
  def save_user_answers(user_answers)
    user_answers.each do |question_id, option_id|
      UserAnswer.create(
        user: current_user,
        assessment: @assessment,
        question_id: question_id,
        selected_option_id: option_id,
        result: @result
      )
    end
  end

  def update_result(user_answers)
    formatted_answers = format_answers(user_answers)
    @score = calculate_score(user_answers)
    @result.update(score: @score, answers: formatted_answers)
  end

  # Giving the answers format as question_id:selceted_option_id|correct_answer_id
  def format_answers(user_answers)
    user_answers.map do |question_id, selected_option_id|
      correct_option_id = find_correct_option_id(question_id.to_i)
      "#{question_id}:#{selected_option_id}|#{correct_option_id}"
    end.join(';')
  end

  def find_correct_option_id(question_id)
    @assessment.questions.find(question_id).options.find_by(correct: true)&.id
  end

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

      correct_option && selected_option_id.to_i == correct_option.id && correct_answers += 1
    end

    correct_answers * 10
  end
end
