class CommentsController < ApplicationController
  # 1. Create comment
  def create
    @post = Post.find(params[:post_id])
    @comment = @post.comments.build(comment_params)
    @comment.account = current_account

    if @comment.save
      redirect_to root_path, notice: "Коментар додано!"
    else
      redirect_to root_path, alert: "Не вдалося додати коментар."
    end
  end

  # 2. Like a comment (feature that was missing)
  def like
    @comment = Comment.find(params[:id])
    # Check whether there is already a like from this account
    @reaction = @comment.comment_reactions.find_by(account: current_account)

    if @reaction
      @reaction.destroy # If present — remove (unlike)
    else
      @comment.comment_reactions.create(account: current_account) # If not present — create one
    end

    redirect_back fallback_location: root_path
  end

  # 3. Deletion (via our special GET route)
  def delete
    destroy
  end

  def destroy
    @post = Post.find(params[:post_id])
    @comment = @post.comments.find(params[:id])

    if @comment.account == current_account
      @comment.destroy
      redirect_back fallback_location: root_path, notice: "Коментар видалено."
    else
      redirect_back fallback_location: root_path, alert: "Ви не можете видалити чужий коментар!"
    end
  end

  private

  def comment_params
    params.require(:comment).permit(:body)
  end
end