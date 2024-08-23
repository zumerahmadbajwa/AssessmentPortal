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
    user_answers = permitted_params[:answers].to_unsafe_h  || {}
    # Create a result record for storing user answers
    @result = Result.create(user: current_user, assessment: @assessment)
    # Iterate over the answers and save them
    if @result.persisted?
    user_answers.each do |question_id, option_id|
      UserAnswer.create(
        user: current_user,
        assessment: @assessment,
        question_id: question_id,
        selected_option_id: option_id,
        result: @result
      )
    end
    # Giving the answers format as question_id:selceted_option_id|correct_answer_id
    formatted_answers = user_answers.map do |question_id, selected_option_id|
      correct_option_id = @assessment.questions.find(question_id.to_i).options.find_by(correct: true)&.id
      "#{question_id}:#{selected_option_id}|#{correct_option_id}"
    end.join(';')

    @score = calculate_score(user_answers)
    @result.update(score: @score, answers: formatted_answers)
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
