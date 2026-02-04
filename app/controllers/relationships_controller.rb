class RelationshipsController < ApplicationController
  # Метод для підписки
  def create
    @account = Account.find(params[:followed_id])
    current_account.following << @account
    
    respond_to do |format|
      format.turbo_stream 
      format.html { redirect_back fallback_location: root_path }
    end
  end

  def destroy
    @relationship = Relationship.find(params[:id])
    @account = @relationship.followed
    @relationship.destroy
    
    respond_to do |format|
      format.turbo_stream
      format.html { redirect_back fallback_location: root_path }
    end
  end
end