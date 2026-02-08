class ReactionsController < ApplicationController
  before_action :require_login

  # Logic to "like" a post
  def create
    # Determine post id from possible param locations
    post_id = params[:post_id] || (params[:reaction] && params[:reaction][:post_id])
    @post = Post.find_by(id: post_id)

    # Build reaction tied to current account and the post as both convenience and polymorphic target
    @reaction = current_account.reactions.build(post: @post)
    @reaction.target = @post if @post

    if @reaction.save
      Rails.logger.debug("Reaction created: ")
    else
      Rails.logger.debug("Reaction failed to save: #{ @reaction.errors.full_messages.join(', ') }")
    end

    # Ensure @post is set so turbo_stream partials can render reliably even on failure
    @post ||= Post.find_by(id: post_id)

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
