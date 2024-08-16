# Assessment Controller
class AssessmentsController < ApplicationController
  before_action :authenticate_user!
  before_action :find_assessment, only: [:show, :attempt, :submit, :results]

  def show
    @questions = @assessment.questions.includes(:options)
  end

  def attempt
    @questions = @assessment.questions.includes(:options)
  end

  def submit
    answers = params[:answers]  # Hash with question_id as key and selected option_id as value
    score = calculate_score(answers)
    Result.create!(user: current_user, assessment: @assessment, score: score, answers: answers.to_json)
    redirect_to results_assessment_path(@assessment), notice: 'Assessment submitted successfully.'
  end

  def results
    @result = Result.find_by(user: current_user, assessment: @assessment)
  end

  private

  def find_assessment
    @assessment = Assessment.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    flash[:alert] = 'Assessment not found.'
    redirect_to assessments_path
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

    # Assuming each question scored 10 points
    correct_answers * 10
  end
end
