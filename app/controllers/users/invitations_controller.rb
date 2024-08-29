module Users
  class InvitationsController < Devise::InvitationsController
    # before_action :authorize_admin!

    # GET /resource/invitation/new
    def new
      self.resource = resource_class.new
      render :new
    end

    # POST /resource/invitation
    def create
      super
    end

    # PUT /resource/invitation
    # This action handles the acceptance of the invitation by the invited user
    def update
      super
    end

    private

    # # Ensures that only admins can send invitations
    # def authorize_admin!
    #   redirect_to(root_path, alert: 'Not authorized') unless current_user.where(rl)
    # end
  end
end