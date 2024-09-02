# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Admin::QuestionsController, type: :controller do
  let(:project) { create(:project) }
  let(:assessment) { create(:assessment, project: project) }
  let(:question) { create(:question, assessment: assessment) }
  let(:admin) { create(:user, :admin) }
  let(:valid_attributes) { { content: 'New Question', options_attributes: [{ content: 'Option 1', correct: true }] } }
  let(:invalid_attributes) { { content: '' } }

  before do
    sign_in admin
  end

  describe 'GET #index' do
    it 'assigns @questions' do
      get :index, params: { project_id: project.id, assessment_id: assessment.id }
      expect(assigns(:questions)).to eq([question])
    end

    it 'renders the :index template' do
      get :index, params: { project_id: project.id, assessment_id: assessment.id }
      expect(response).to render_template(:index)
    end
  end

  describe 'GET #new' do
    it 'assigns a new question to @question' do
      get :new, params: { project_id: project.id, assessment_id: assessment.id }
      expect(assigns(:question)).to be_a_new(Question)
    end

    it 'renders the :new template' do
      get :new, params: { project_id: project.id, assessment_id: assessment.id }
      expect(response).to render_template(:new)
    end
  end

  describe 'POST #create' do
    context 'with valid attributes' do
      it 'creates a new Question' do
        expect do
          post :create, params: { project_id: project.id, assessment_id: assessment.id, question: valid_attributes }
        end.to change(Question, :count).by(1)
      end

      it 'redirects to the assessment show page' do
        post :create, params: { project_id: project.id, assessment_id: assessment.id, question: valid_attributes }
        expect(response).to redirect_to(admin_project_assessment_path(project, assessment))
      end
    end

    context 'with invalid attributes' do
      it 'does not create a new Question' do
        expect do
          post :create, params: { project_id: project.id, assessment_id: assessment.id, question: invalid_attributes }
        end.to_not change(Question, :count)
      end

      it 're-renders the :new template' do
        post :create, params: { project_id: project.id, assessment_id: assessment.id, question: invalid_attributes }
        expect(response).to render_template(:new)
      end
    end
  end

  describe 'GET #edit' do
    it 'assigns the requested question to @question' do
      get :edit, params: { project_id: project.id, assessment_id: assessment.id, id: question.id }
      expect(assigns(:question)).to eq(question)
    end

    it 'renders the :edit template' do
      get :edit, params: { project_id: project.id, assessment_id: assessment.id, id: question.id }
      expect(response).to render_template(:edit)
    end
  end

  describe 'PATCH/PUT #update' do
    let(:new_attributes) { { content: 'Updated Question' } } # New data for updating the question
    context 'with valid attributes' do
      it 'updates the requested question' do
        # Send a PATCH request to update the question with new attributes
        patch :update, params: {
          project_id: project.id,
          assessment_id: assessment.id,
          id: question.id,
          question: new_attributes
        }
        question.reload
        expect(question.content).to eq('Updated Question')
      end

      it 'redirects to the question show page' do
        patch :update, params: {
          project_id: project.id,
          assessment_id: assessment.id,
          id: question.id,
          question: new_attributes
        }
        expect(response).to redirect_to(admin_project_assessment_question_path(project, assessment, question))
      end
    end

    context 'with invalid attributes' do
      it 'does not update the question' do
        patch :update, params: {
          project_id: project.id,
          assessment_id: assessment.id,
          id: question.id,
          question: invalid_attributes
        }
        question.reload
        expect(question.content).to_not eq('')
      end

      it 're-renders the :edit template' do
        patch :update, params: {
          project_id: project.id,
          assessment_id: assessment.id,
          id: question.id,
          question: invalid_attributes
        }
        expect(response).to render_template(:edit)
      end
    end
  end

  describe 'DELETE #destroy' do
    it 'destroys the requested question' do
      question # Create the question before testing destruction
      expect do
        delete :destroy, params: { project_id: project.id, assessment_id: assessment.id, id: question.id }
      end.to change(Question, :count).by(-1)
    end

    it 'redirects to the questions list' do
      delete :destroy, params: { project_id: project.id, assessment_id: assessment.id, id: question.id }
      expect(response).to redirect_to(admin_project_assessments_path(assessment))
    end
  end
end
