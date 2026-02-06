class ReactionsController < ApplicationController
  before_action :require_login

  # Logic to "like" a post
  def create
    @reaction = Reaction.new(reaction_params)
    @reaction.account = current_account

    @post = @reaction.post if @reaction.save

    respond_to do |format|
      format.turbo_stream
      format.html { redirect_back fallback_location: root_path }
    end
  end

  # Logic to "unlike" a post
  def destroy
    @reaction = Reaction.find(params[:id])
    @post = @reaction.post
    @reaction.destroy

    respond_to do |format|
      format.turbo_stream
      format.html { redirect_back fallback_location: root_path }
    end
  end

  private

  def reaction_params
    params.require(:reaction).permit(:post_id)
  end
end
