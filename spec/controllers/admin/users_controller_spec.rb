require 'rails_helper'

RSpec.describe Admin::UsersController, type: :controller do
  let(:user) { create(:user) }

  describe 'GET #index' do
    it 'assigns all users to @users' do
      get :index
      expect(assigns(:users)).to eq([user])
    end

    it 'renders the index template' do
      get :index
      expect(response).to render_template(:index)
    end
  end

  describe 'GET #new' do
    it 'assigns a new user to @user' do
      get :new
      expect(assigns(:user)).to be_a_new(User)
    end

    it 'renders the new template' do
      get :new
      expect(response).to render_template(:new)
    end
  end

  describe 'POST #create' do
    context 'with valid attributes' do
      it 'creates a new user' do
        expect {
          post :create, params: { user: attributes_for(:user) }
        }.to change(User, :count).by(1)
      end

      it 'redirects to the admin users path' do
        post :create, params: { user: attributes_for(:user) }
        expect(response).to redirect_to(admin_users_path)
      end
    end

    context 'with invalid attributes' do
      it 'does not create a new user' do
        expect {
          post :create, params: { user: attributes_for(:user, email: nil) }
        }.not_to change(User, :count)
      end

      it 're-renders the new template' do
        post :create, params: { user: attributes_for(:user, email: nil) }
        expect(response).to render_template(:new)
      end
    end
  end

  describe 'GET #edit' do
    it 'assigns the requested user to @user' do
      get :edit, params: { id: user.id }
      expect(assigns(:user)).to eq(user)
    end

    it 'renders the edit template' do
      get :edit, params: { id: user.id }
      expect(response).to render_template(:edit)
    end
  end

  describe 'PATCH #update' do
    context 'with valid attributes' do
      it 'updates the user' do
        patch :update, params: { id: user.id, user: { username: 'NewUsername' } }
        user.reload
        expect(user.username).to eq('NewUsername')
      end

      it 'redirects to the admin users path' do
        patch :update, params: { id: user.id, user: { username: 'NewUsername' } }
        expect(response).to redirect_to(admin_users_path)
      end
    end

    context 'with invalid attributes' do
      it 'does not update the user' do
        patch :update, params: { id: user.id, user: { email: nil } }
        user.reload
        expect(user.email).not_to eq(nil)
      end

      it 're-renders the edit template' do
        patch :update, params: { id: user.id, user: { email: nil } }
        expect(response).to render_template(:edit)
      end
    end
  end

  describe 'DELETE #destroy' do
    it 'deletes the user' do
      user
      expect {
        delete :destroy, params: { id: user.id }
      }.to change(User, :count).by(-1)
    end

    it 'redirects to the admin users path' do
      delete :destroy, params: { id: user.id }
      expect(response).to redirect_to(admin_users_path)
    end
  end

  describe 'GET #delete_modal' do
    before do
      get :delete_modal, params: { user_id: user.id }
    end

    it 'assigns the requested user to @user' do
      expect(assigns(:user)).to eq(user)
    end

    it 'renders the delete_modal template' do
      expect(response).to render_template(partial: '_delete_modal')
    end
  end
end
