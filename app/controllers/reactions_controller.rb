class ReactionsController < ApplicationController
  # Logic to "like" a post
  def create
    @post = Post.find(params[:post_id])
    
    if current_account
      current_account.reactions.find_or_create_by(post: @post)
    end

    respond_to do |format|
      format.turbo_stream
      format.html { redirect_back fallback_location: root_path }
    end
  end

  # Logic to "unlike" a post
  def destroy
    @reaction = current_account.reactions.find(params[:id])
    @post = @reaction.post
    @reaction.destroy

    respond_to do |format|
      format.turbo_stream
      format.html { redirect_back fallback_location: root_path }
    end
  end
end