class ProfilesController < ApplicationController
  def show
    # Find the profile by username from the URL (e.g. user_2)
    @profile = Profile.find_by!(username: params[:id])
    
    # Get all posts for this account
    @posts = @profile.account.posts.order(created_at: :desc)
  end
end