# app/controllers/registrations_controller.rb
class RegistrationsController < Devise::RegistrationsController
  def new
    @token = params[:invite_token]
    resource = build_resource({})
    resource.companies.build
    if @token != nil
      invite = Invite.find_by_token(@token)
      if invite.present?
        if invite.recipient.present?
          flash[:notice] = "You already joined as a Member in #{invite.company.name}. Please Sign In."
          redirect_to new_user_session_path
        else
          resource.email = invite.email
          respond_with resource
        end
      else
        flash[:error] = "Sorry invalid invitation. Register as a new user (or) Contact sender to send join request again."
        redirect_to new_user_registration_path
      end
    else
      respond_with resource
    end
  end

  def create
    @token = params[:invite_token]
    super
    resource.save
    if @token != nil
      invite = Invite.find_by_token(@token)
      resource.companies.push(invite.company) #add this user to the new user group as a member
      invite.recipient = resource
      invite.save!
    end
  end

  protected

  def after_inactive_sign_up_path_for(resource)
    if @token != nil
      invite = Invite.find_by_token(@token)
      flash[:notice] = "You successfully joined as a Member in #{invite.company.name}. Confirm your account and Login."
    end
    super
  end

  private

  def sign_up_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation, :companies_attributes => [:name])
  end

  def account_update_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation, :current_password)
  end
end