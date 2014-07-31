require 'api_controller'
class HomeController < ApplicationController
  def index
    subdomain = request.subdomains(0).first
    if not User.where(subdomain: subdomain).blank?
      redirect_to User.find_by_subdomain(subdomain).hangout_url
      return
    end

  	if user_signed_in?
  		redirect_to profile_path
  		return
  	end
  end

  def profile
  	if not user_signed_in?
  		redirect_to :root
  		return
  	end

    @user = current_user

  end

  def update
    current_user.update_attributes(user_params)
    if current_user.valid?
      current_user.save!
      flash[:notice] = "Updated successfully."
      redirect_to profile_path
    else
      flash[:notice] = current_user.errors[:subdomain]
      redirect_to profile_path
    end

  end

  def signup
    if self.validate_subdomain(params[:subdomain])[:valid]
      render params[:page]  
    else
      redirect_to root_path
    end
  end

  private
  
  def user_params
    params.require(:user).permit(:name, :subdomain)
  end

end
