# frozen_string_literal: true

module Admin
  # Project Controller
  class ProjectsController < ApplicationController
    before_action :find_project, only: %i[show edit update destroy]
    protect_from_forgery except: :delete_modal

    def index
      @q = Project.ransack(params[:q])
      @projects = @q.result
    end

    def new
      @project = Project.new
    end

    def create
      @project = Project.new(project_params)
      if @project.save
        # Optionally associate additional users (e.g., from a form input)
        # if params[:project][:user_ids]
        #   additional_users = User.where(id: params[:project][:user_ids])
        #   @project.users << additional_users
        # end
        redirect_to admin_project_path(@project), notice: 'Project was successfully created.'
      else
        render 'new'
      end
    end

    def show; end

    def update
      if @project.update(project_params)
        redirect_to admin_project_path(@project), notice: 'Project was successfully updated.'
      else
        render :edit
      end
    end

    def edit; end

    def destroy
      if @project
        @project.destroy
        redirect_to admin_projects_path, notice: 'Project was successfully destroyed.'
      else
        redirect_to admin_projects_path, alert: 'Project not found.'
      end
    end

    def delete_modal
      @project = Project.find(params[:project_id])
      respond_to do |format|
        format.js   # Render `delete_modal.js.erb` if the request is JS
        format.html # For non-AJAX requests, render the full template if necessary
      end
    end

    private

    def find_project
      @project = Project.find(params[:id])
    end

    def project_params
      params.require(:project).permit(:title, :description, :start_date, :end_date, :status, user_ids: [])
    end
  end
end
