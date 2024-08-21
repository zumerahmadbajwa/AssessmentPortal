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
    answers = params[:answers]
    puts "Answers received: #{answers.inspect}" 
    score = calculate_score(answers)
    flash[:notice] = "Your score: #{score}"
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
  
    puts "Answers received: #{answers.inspect}"
  
    @assessment.questions.each do |question|
      selected_option_id = answers[question.id.to_s] || answers[question.id.to_s] || answers[question.id]
      correct_option = question.options.find_by(correct: true)
  
      puts "Question ID: #{question.id}"
      puts "Selected Option ID: #{selected_option_id}"
      puts "Correct Option ID: #{correct_option&.id}"
  
      if correct_option && selected_option_id.to_i == correct_option.id
        correct_answers += 1
      end
    end
  
    puts "Total Correct Answers: #{correct_answers}"
  
    correct_answers * 10
  end
end
