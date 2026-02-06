class CommentsController < ApplicationController
  # Видалили :delete звідси, бо методу delete не існує
  before_action :require_login, only: %i[create like unlike destroy]

  # 1. Create comment
  def create
    @post = Post.find(params[:post_id])
    @comment = @post.comments.build(comment_params)
    @comment.account = current_account

    if @comment.save
      redirect_to root_path, notice: 'Коментар додано!'
    else
      redirect_to root_path, alert: 'Не вдалося додати коментар.'
    end
  end

  def like
    @comment = Comment.find(params[:id])
    @post = @comment.post # Важливо для знаходження ID на сторінці
    @comment.comment_reactions.find_or_create_by(account: current_account)

    respond_to do |format|
      format.turbo_stream
      format.html { redirect_back fallback_location: root_path }
    end
  end

  def unlike
    @comment = Comment.find(params[:id])
    @post = @comment.post
    @reaction = @comment.comment_reactions.find_by(account: current_account)
    @reaction&.destroy

    respond_to do |format|
      format.turbo_stream
      format.html { redirect_back fallback_location: root_path }
    end
  end

  # 4. Destroy comment
  def destroy
    @post = Post.find(params[:post_id])
    @comment = @post.comments.find(params[:id])

    if @comment.account == current_account
      @comment.destroy
      respond_to do |format|
        format.turbo_stream
        format.html { redirect_back fallback_location: root_path, notice: 'Comment removed.' }
      end
    else
      respond_to do |format|
        format.turbo_stream { head :forbidden }
        format.html { redirect_back fallback_location: root_path, alert: 'You cannot delete someone else\'s comment!' }
      end
    end
  end

  private

  def comment_params
    params.require(:comment).permit(:body)
  end
end
