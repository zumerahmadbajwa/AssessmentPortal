# frozen_string_literal: true

module Users
  # Invitation Controller
  class InvitationsController < Devise::InvitationsController
    # before_action :authorize_admin!

    # GET /resource/invitation/new
    def new
      self.resource = resource_class.new
      render :new
    end

    # # Ensures that only admins can send invitations
    # def authorize_admin!
    #   redirect_to(root_path, alert: 'Not authorized') unless current_user.where(rl)
    # end
  end
end
