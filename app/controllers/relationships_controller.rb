class RelationshipsController < ApplicationController
  # Create a new follow relationship
  def create
    # Find the user you want to follow by followed_id
    user = Account.find(params[:followed_id])
    
    # Add this user to your 'following' list
    current_account.following << user
    
    redirect_back fallback_location: root_path, notice: "You are now following #{user.username}"
  end

  # Delete an existing follow relationship
  def destroy
    # Find the relationship record to remove it
    relationship = Relationship.find(params[:id])
    user = relationship.followed
    
    current_account.following.delete(user)
    
    redirect_back fallback_location: root_path, notice: "Unfollowed #{user.username}"
  end
end