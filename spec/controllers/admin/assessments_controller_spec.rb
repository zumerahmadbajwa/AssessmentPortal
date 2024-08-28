# spec/controllers/admin/assessments_controller_spec.rb
require 'rails_helper'

RSpec.describe Admin::AssessmentsController, type: :controller do
  let(:project) { create(:project) }
  let(:assessment) { create(:assessment, project: project) }
  let(:admin) { create(:user, :admin) }

  before do
    sign_in admin
  end

  describe 'GET #index' do
    it 'assigns @assessments' do
      get :index, params: { project_id: project.id }
      expect(assigns(:assessments)).to eq([assessment])
    end

    it 'renders the index template' do
      get :index, params: { project_id: project.id }
      expect(response).to render_template(:index)
    end
  end

  describe 'GET #show' do
    it 'assigns @assessment' do
      get :show, params: { project_id: project.id, id: assessment.id }
      expect(assigns(:assessment)).to eq(assessment)
    end

    it 'renders the show template' do
      get :show, params: { project_id: project.id, id: assessment.id }
      expect(response).to render_template(:show)
    end
  end

  describe 'GET #new' do
    it 'assigns a new assessment as @assessment' do
      get :new, params: { project_id: project.id }
      expect(assigns(:assessment)).to be_a_new(Assessment)
    end

    it 'renders the new template' do
      get :new, params: { project_id: project.id }
      expect(response).to render_template(:new)
    end
  end

  describe 'POST #create' do
    context 'with valid attributes' do
      it 'creates a new Assessment' do
        expect {
          post :create, params: {
            project_id: project.id,
            assessment: attributes_for(:assessment)
          }
        }.to change(Assessment, :count).by(1)
      end

      it 'assigns the newly created assessment as @assessment' do
        post :create, params: {
          project_id: project.id,
          assessment: attributes_for(:assessment)
        }
        expect(assigns(:assessment)).to be_persisted
      end

      it 'redirects to the created assessment' do
        post :create, params: {
          project_id: project.id,
          assessment: attributes_for(:assessment)
        }
        expect(response).to redirect_to(admin_project_assessment_path(project, Assessment.last))
      end
    end

    context 'with invalid attributes' do
      it 'does not save the new assessment' do
        expect {
          post :create, params: {
            project_id: project.id,
            assessment: attributes_for(:assessment, title: nil)
          }
        }.to_not change(Assessment, :count)
      end

      it 're-renders the new template' do
        post :create, params: {
          project_id: project.id,
          assessment: attributes_for(:assessment, title: nil)
        }
        expect(response).to render_template(:new)
      end
    end
  end

  describe 'GET #edit' do
    it 'assigns the requested assessment as @assessment' do
      get :edit, params: { project_id: project.id, id: assessment.id }
      expect(assigns(:assessment)).to eq(assessment)
    end

    it 'renders the edit template' do
      get :edit, params: { project_id: project.id, id: assessment.id }
      expect(response).to render_template(:edit)
    end
  end

  describe 'PUT #update' do
    context 'with valid attributes' do
      it 'updates the requested assessment' do
        put :update, params: {
          project_id: project.id,
          id: assessment.id,
          assessment: { title: 'Updated Title' }
        }
        assessment.reload
        expect(assessment.title).to eq('Updated Title')
      end

      it 'redirects to the assessment' do
        put :update, params: {
          project_id: project.id,
          id: assessment.id,
          assessment: { title: 'Updated Title' }
        }
        expect(response).to redirect_to(admin_project_assessment_path(project, assessment))
      end
    end

    context 'with invalid attributes' do
      it 'does not update the assessment' do
        put :update, params: {
          project_id: project.id,
          id: assessment.id,
          assessment: { title: nil }
        }
        expect(assessment.title).not_to be_nil
      end

      it 're-renders the edit template' do
        put :update, params: {
          project_id: project.id,
          id: assessment.id,
          assessment: { title: nil }
        }
        expect(response).to render_template(:edit)
      end
    end
  end

  describe 'DELETE #destroy' do
    it 'destroys the requested assessment' do
      assessment
      expect {
        delete :destroy, params: { project_id: project.id, id: assessment.id }
      }.to change(Assessment, :count).by(-1)
    end

    it 'redirects to the assessments list' do
      delete :destroy, params: { project_id: project.id, id: assessment.id }
      expect(response).to redirect_to(admin_project_assessments_path(project))
    end
  end
end
