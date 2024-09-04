# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Admin::ProjectUsersController, type: :controller do
  let(:project) { create(:project) }
  let(:user) { create(:user) }
  let(:admin) { create(:user, :admin) }

  before do
    sign_in admin
  end

  describe 'GET #index' do
    it 'assigns @project_users and @users' do
      project.users << user
      get :index, params: { project_id: project.id }

      expect(assigns(:project_users)).to eq([user])
      expect(assigns(:users)).to eq(User.all - project.users)
      expect(response).to render_template(:index)
    end
  end

  describe 'POST #create' do
    context 'when the user is not already associated with the project' do
      it 'adds the user to the project' do
        post :create, params: { project_id: project.id, user_id: user.id }

        expect(project.users).to include(user)
        expect(response).to redirect_to(admin_project_project_users_path(project))
      end
    end

    context 'when the user is already associated with the project' do
      before do
        project.users << user
      end

      it 'does not add the user to the project and shows an alert' do
        post :create, params: { project_id: project.id, user_id: user.id }

        expect(project.users.count).to eq(1) # Ensure no duplicate association
        expect(response).to redirect_to(admin_project_project_users_path(project))
      end
    end
  end

  describe 'DELETE #destroy' do
    before do
      project.users << user
    end

    it 'removes the user from the project' do
      expect(project.users).to include(user) # Verify user is initially added
      delete :destroy, params: { project_id: project.id, id: user.id }

      project.reload
      expect(project.users.reload).not_to include(user)
      expect(response).to redirect_to(admin_project_project_users_path(project))
    end
  end
end
