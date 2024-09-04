# frozen_string_literal: true

module Admin
  # User Controller
  class UsersController < ApplicationController
    before_action :find_user, only: %i[show edit update destroy]
    protect_from_forgery except: :delete_modal

    def index
      @q = User.ransack(params[:q])
      @users = @q.result
    end

    def new
      @user = User.new
    end

    def create
      @user = User.new(user_params)
      if @user.save
        redirect_to admin_users_path
      else
        render 'new'
      end
    end

    def show; end

    def update
      if @user.update(user_params)
        redirect_to admin_users_path
      else
        render 'edit'
      end
    end

    def edit; end

    def destroy
      @user.destroy
      redirect_to admin_users_path
    end

    def delete_modal
      @user = User.find(params[:user_id])
      respond_to do |format|
        format.js   # Render `delete_modal.js.erb` if the request is JS
        format.html # For non-AJAX requests, render the full template if necessary
      end
    end

    private

    def find_user
      @user = User.find(params[:id])
    end

    def user_params
      params.require(:user).permit(:username, :email, :password)
    end
  end
end
