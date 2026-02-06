class ProfilesController < ApplicationController
  before_action :set_account
  before_action :require_login

  # Display the edit form
  def edit; end

  # Update account information
  def update
    if @account.update(account_params)
      redirect_to my_profile_path, notice: 'Profile updated successfully.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def set_account
    @account = current_account
  end

  # Strong parameters to allow avatar and description
  def account_params
    params.require(:account).permit(:username, :description, :avatar)
  end
end
