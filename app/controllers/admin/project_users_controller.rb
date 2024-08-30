# frozen_string_literal: true

module Admin
  # ProjectUser Controller
  class ProjectUsersController < ApplicationController
    before_action :set_project

    def index
      @project_users = @project.users
      @users = User.all - @project.users
    end

    def create
      user = User.find(params[:user_id])
      if @project.users.include?(user)
        @project.users << user
        flash[:notice] = 'User was successfully added to the project.'
      else
        flash[:alert] = 'User is already associated with this project.'
      end
      redirect_to admin_project_project_users_path(@project)
    end

    def destroy
      user = User.find(params[:id])
      @project.users.delete(user)
      flash[:notice] = 'User was successfully removed from the project.'
      redirect_to admin_project_project_users_path(@project)
    end

    private

    def set_project
      @project = Project.find(params[:project_id])
    end
  end
end
