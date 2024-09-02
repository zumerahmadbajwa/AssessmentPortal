# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Admin::ProjectsController, type: :controller do
  let(:admin) { create(:user, :admin) }
  let(:project) { create(:project) }
  let(:valid_attributes) do
    {
      title: 'New Project',
      description: 'Description',
      start_date: Date.today,
      end_date: Date.tomorrow,
      status: 'active'
    }
  end
  let(:invalid_attributes) do
    {
      title: '',
      description: '',
      start_date: '',
      end_date: '',
      status: ''
    }
  end

  before do
    sign_in admin
  end

  describe 'GET #index' do
    it 'assigns all projects as @projects' do
      project1 = create(:project)
      project2 = create(:project)
      get :index
      expect(assigns(:projects)).to match_array([project1, project2])
    end

    it 'renders the index template' do
      get :index
      expect(response).to render_template(:index)
    end
  end

  describe 'GET #show' do
    it 'assigns the requested project as @project' do
      get :show, params: { id: project.to_param }
      expect(assigns(:project)).to eq(project)
    end

    it 'renders the show template' do
      get :show, params: { id: project.to_param }
      expect(response).to render_template(:show)
    end
  end

  describe 'GET #new' do
    it 'assigns a new project as @project' do
      get :new
      expect(assigns(:project)).to be_a_new(Project)
    end

    it 'renders the new template' do
      get :new
      expect(response).to render_template(:new)
    end
  end

  describe 'POST #create' do
    context 'with valid params' do
      it 'creates a new Project' do
        expect do
          post :create, params: { project: valid_attributes }
        end.to change(Project, :count).by(1)
      end

      it 'redirects to the created project' do
        post :create, params: { project: valid_attributes }
        expect(response).to redirect_to(admin_project_path(Project.last))
      end

      it 'sets a notice flash message' do
        post :create, params: { project: valid_attributes }
        expect(flash[:notice]).to eq('Project was successfully created.')
      end
    end

    context 'with invalid params' do
      it 'does not create a new Project' do
        expect do
          post :create, params: { project: invalid_attributes }
        end.to change(Project, :count).by(0)
      end

      it 'renders the new template' do
        post :create, params: { project: invalid_attributes }
        expect(response).to render_template(:new)
      end
    end
  end

  describe 'GET #edit' do
    it 'assigns the requested project as @project' do
      get :edit, params: { id: project.to_param }
      expect(assigns(:project)).to eq(project)
    end

    it 'renders the edit template' do
      get :edit, params: { id: project.to_param }
      expect(response).to render_template(:edit)
    end
  end

  describe 'PATCH/PUT #update' do
    context 'with valid params' do
      it 'updates the requested project' do
        patch :update, params: { id: project.to_param, project: valid_attributes }
        project.reload
        expect(project.title).to eq('New Project')
      end

      it 'redirects to the project' do
        patch :update, params: { id: project.to_param, project: valid_attributes }
        expect(response).to redirect_to(admin_project_path(project))
      end

      it 'sets a notice flash message' do
        patch :update, params: { id: project.to_param, project: valid_attributes }
        expect(flash[:notice]).to eq('Project was successfully updated.')
      end
    end

    context 'with invalid params' do
      it 'does not update the project' do
        patch :update, params: { id: project.to_param, project: invalid_attributes }
        project.reload
        expect(project.title).not_to eq('')
      end

      it 'renders the edit template' do
        patch :update, params: { id: project.to_param, project: invalid_attributes }
        expect(response).to render_template(:edit)
      end
    end
  end

  describe 'DELETE #destroy' do
    it 'destroys the requested project' do
      project_to_destroy = create(:project)
      expect do
        delete :destroy, params: { id: project_to_destroy.to_param }
      end.to change(Project, :count).by(-1)
    end

    it 'redirects to the projects list' do
      delete :destroy, params: { id: project.to_param }
      expect(response).to redirect_to(admin_projects_path)
    end

    it 'sets a notice flash message' do
      delete :destroy, params: { id: project.to_param }
      expect(flash[:notice]).to eq('Project was successfully destroyed.')
    end
  end

  describe 'GET #delete_modal' do
    before do
      get :delete_modal, params: { project_id: project.id }
    end

    it 'assigns the requested project to @project' do
      expect(assigns(:project)).to eq(project)
    end

    it 'renders the delete_modal template' do
      expect(response).to render_template(partial: '_delete_modal')
    end
  end
end
