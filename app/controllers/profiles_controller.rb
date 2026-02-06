class ProfilesController < ApplicationController
  before_action :set_account, only: [:edit, :update]

  # Display the edit form
  def edit
  end

  # Update account information
  def update
    if @account.update(account_params)
      redirect_to my_profile_path, notice: "Profile updated successfully."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def show
    @account = Account.find(params[:id])
    # Backwards-compatible @profile object (previously there was a Profile model)
    # Use AccountPresenter so views that reference @profile still work.
    @posts = @account.posts.order(created_at: :desc)
    @profile = AccountPresenter.new(@account)
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