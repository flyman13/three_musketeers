class PostsController < ApplicationController
  before_action :set_post, only: [:show, :destroy, :delete, :like]

  def index
    @posts = Post.includes(:account, :comments, :reactions).all.order(created_at: :desc)
  end

  def show
    # @post is already found by set_post
  end

  def new
    @post = current_account.posts.build
  end

  def create
    @post = current_account.posts.build(post_params)
    if @post.save
      redirect_to root_path, notice: "Пост створено!"
    else
      # status: :unprocessable_entity is important for Rails 7 so the form displays errors
      render :new, status: :unprocessable_entity
    end
  end

  def delete
    destroy
  end

  def destroy
    if @post.account == current_account
      @post.destroy
      redirect_to root_path, notice: "Допис успішно видалено.", status: :see_other
    else
      redirect_to root_path, alert: "Ви не можете видаляти чужі дописи!"
    end
  end

  def like
    @reaction = Reaction.find_by(account_id: current_account.id, post_id: @post.id)

    if @reaction
      @reaction.destroy
    else
      Reaction.create(account_id: current_account.id, post_id: @post.id)
    end

    redirect_back fallback_location: root_path
  end

  def my_profile
    # Find posts only for the current account
    @posts = current_account.posts.order(created_at: :desc)

    # Use the same view file as the main page
    render :index 
  end

  private

  def set_post
    @post = Post.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to root_path, alert: "Допис не знайдено."
  end

  def post_params
    # Make sure to permit :image for uploading photos
    params.require(:post).permit(:body, :image)
  end

end