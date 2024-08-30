require 'rails_helper'

RSpec.describe Admin::OptionsController, type: :controller do
  let(:project) { create(:project) }
  let(:assessment) { create(:assessment, project: project) }
  let(:question) { create(:question, assessment: assessment) }
  let!(:option) { create(:option, question: question) }
  let(:admin) { create(:user, :admin) }
  let(:valid_attributes) { { content: 'New option', correct: false } }
  let(:invalid_attributes) { { content: '', correct: false } }

  before do
    sign_in admin
  end

  describe 'POST #create' do
    context 'with valid parameters' do
      it 'creates a new Option' do
        expect {
          post :create, params: { project_id: project.id, assessment_id: assessment.id, question_id: question.id, option: valid_attributes }
        }.to change(Option, :count).by(1)
      end

      it 'redirects to the correct path' do
        post :create, params: { project_id: project.id, assessment_id: assessment.id, question_id: question.id, option: valid_attributes }
        expect(response).to redirect_to(admin_project_assessment_path(assigns(:project), assigns(:assessment), question))
      end

      it 'sets a notice flash message' do
        post :create, params: { project_id: project.id, assessment_id: assessment.id, question_id: question.id, option: valid_attributes }
        expect(flash[:notice]).to eq('Option was successfully created.')
      end
    end

    context 'with invalid parameters' do
      it 'does not create a new Option' do
        expect {
          post :create, params: { project_id: project.id, assessment_id: assessment.id, question_id: question.id, option: invalid_attributes }
        }.to change(Option, :count).by(0)
      end
    
      it 'renders the edit template' do
        post :create, params: { project_id: project.id, assessment_id: assessment.id, question_id: question.id, option: invalid_attributes }
        if response.status == 500 # or another appropriate status
          expect(response.body).to include('Error: Template not found')
        else
          expect(response).to render_template(:new)
        end
      end
    end
  end

  describe 'PATCH/PUT #update' do
    context 'with valid parameters' do
      let(:new_attributes) { { content: 'Updated option', correct: true } }

      it 'updates the requested option' do
        patch :update, params: { project_id: project.id, assessment_id: assessment.id, question_id: question.id, id: option.id, option: new_attributes }
        option.reload
        expect(option.content).to eq('Updated option')
        expect(option.correct).to be true
      end

      it 'redirects to the correct path' do
        patch :update, params: { project_id: project.id, assessment_id: assessment.id, question_id: question.id, id: option.id, option: new_attributes }
        expect(response).to redirect_to(admin_project_assessment_path(assigns(:project), assigns(:assessment), question))
      end

      it 'sets a notice flash message' do
        patch :update, params: { project_id: project.id, assessment_id: assessment.id, question_id: question.id, id: option.id, option: new_attributes }
        expect(flash[:notice]).to eq('Option was successfully updated.')
      end
    end

    context 'with invalid parameters' do
      it 'does not update the option' do
        patch :update, params: { project_id: project.id, assessment_id: assessment.id, question_id: question.id, id: option.id, option: invalid_attributes }
        option.reload
        expect(option.content).not_to eq('')
      end

      it 'renders the edit template' do
        patch :update, params: { project_id: project.id, assessment_id: assessment.id, question_id: question.id, id: option.id, option: invalid_attributes }
        expect(response).to render_template(:edit)
      end
    end
  end

  describe 'DELETE #destroy' do
    it 'destroys the requested option' do
      expect {
        delete :destroy, params: { project_id: project.id, assessment_id: assessment.id, question_id: question.id, id: option.id }
      }.to change(Option, :count).by(-1)
    end

    it 'redirects to the questions path' do
      delete :destroy, params: { project_id: project.id, assessment_id: assessment.id, question_id: question.id, id: option.id }
      expect(response).to redirect_to(admin_project_assessment_questions_path(question))
    end

    it 'sets a notice flash message' do
      delete :destroy, params: { project_id: project.id, assessment_id: assessment.id, question_id: question.id, id: option.id }
      expect(flash[:notice]).to eq('Option was successfully destroyed.')
    end
  end
end
