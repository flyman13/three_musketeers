class ReactionsController < ApplicationController
  before_action :require_login

  # Logic to "like" a post
  def create
    # Build reaction robustly from either nested params or top-level post_id
    @reaction = current_account.reactions.build
    post_id = params[:post_id] || (params[:reaction] && params[:reaction][:post_id])
    @reaction.post = Post.find(post_id) if post_id

    # Set polymorphic target to the post so required target_type/target_id are present
    @reaction.target = @reaction.post

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
