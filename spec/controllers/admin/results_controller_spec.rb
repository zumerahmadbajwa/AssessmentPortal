# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Admin::ResultsController, type: :controller do
  let(:project) { create(:project) }
  let(:assessment) { create(:assessment, project: project) }
  let(:result) { create(:result, assessment: assessment) }
  let(:admin) { create(:user, :admin) }

  before do
    sign_in admin
  end

  describe 'GET #index' do
    it 'assigns the requested assessment to @assessment' do
      get :index, params: { project_id: project.id, assessment_id: assessment.id }
      expect(assigns(:assessment)).to eq(assessment)
    end

    it 'assigns the results of the assessment to @results' do
      result # Ensure the result is created
      get :index, params: { project_id: project.id, assessment_id: assessment.id }
      expect(assigns(:results)).to include(result)
    end

    it 'renders the index template' do
      get :index, params: { project_id: project.id, assessment_id: assessment.id }
      expect(response).to render_template(:index)
    end
  end

  describe 'GET #show' do
    it 'assigns the requested result to @result' do
      get :show, params: { project_id: project.id, assessment_id: assessment.id, id: result.id }
      expect(assigns(:result)).to eq(result)
    end

    it 'renders the show template' do
      get :show, params: { project_id: project.id, assessment_id: assessment.id, id: result.id }
      expect(response).to render_template(:show)
    end
  end

  describe 'DELETE #destroy' do
    it 'destroys the requested result' do
      result # Ensure the result is created
      expect do
        delete :destroy, params: { project_id: project.id, assessment_id: assessment.id, id: result.id }
      end.to change(Result, :count).by(-1)
    end

    it 'redirects to the results list' do
      delete :destroy, params: { project_id: project.id, assessment_id: assessment.id, id: result.id }
      expect(response).to redirect_to(admin_project_assessment_results_path(project, assessment))
    end
  end
end
