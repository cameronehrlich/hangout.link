class HomeController < ApplicationController
  def index
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

  private
  
  def user_params
    params.require(:user).permit(:name, :subdomain)
  end

end
