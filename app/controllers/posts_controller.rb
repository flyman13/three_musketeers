class PostsController < ApplicationController
  before_action :set_post, :require_login, only: %i[show destroy delete like save unsave]
  before_action :require_login, only: %i[new create my_profile]

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
  # pass the permitted `post_params` directly to the service; the service knows how to
  # handle either a Hash or ActionController::Parameters
  service = Posts::CreatePostService.new(current_account, post_params)
    @post = service.call

    if @post.persisted?
      redirect_to root_path, notice: 'Post created!'
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
      redirect_to root_path, notice: 'Допис успішно видалено.', status: :see_other
    else
      redirect_to root_path, alert: 'Ви не можете видаляти чужі дописи!'
    end
  end

  def like
    result = TogglePostLike.call(account: current_account, post: @post)

    respond_to do |format|
      format.html { redirect_back fallback_location: root_path }
      format.turbo_stream do
        streams = []
        # always replace the like button partial to reflect current state
        streams << turbo_stream.replace("like_post_#{@post.id}", partial: 'posts/like_button', locals: { post: @post })

        unless result.success?
          # prepend an alert message into the #flash container
          alert_html = ApplicationController.render(inline: "<div class='alert alert-danger'>#{ERB::Util.html_escape(result.message)}</div>")
          streams << turbo_stream.prepend('flash', alert_html)
        end

        render turbo_stream: streams
      end
    end
  end

  def save
    saved = SavedPost.find_by(account_id: current_account.id, post_id: @post.id)
    SavedPost.create(account_id: current_account.id, post_id: @post.id) unless saved

    respond_to do |format|
      format.html { redirect_back fallback_location: root_path }
      format.turbo_stream do
        render turbo_stream: turbo_stream.replace("post_actions_#{@post.id}", partial: 'posts/post_actions',
                                                                              locals: { post: @post })
      end
    end
  end

  def unsave
    saved = SavedPost.find_by(account_id: current_account.id, post_id: @post.id)
    saved&.destroy

    respond_to do |format|
      format.html { redirect_back fallback_location: root_path }
      format.turbo_stream do
        render turbo_stream: turbo_stream.replace("post_actions_#{@post.id}", partial: 'posts/post_actions',
                                                                              locals: { post: @post })
      end
    end
  end

  def my_profile
    # Find posts only for the current account and optionally show saved posts
    @account = current_account
    @tab = params[:tab].presence_in(%w[posts saved liked]) || 'posts'
    @posts = current_account.posts.order(created_at: :desc)
    @saved_posts = current_account.saved.order(created_at: :desc)
  # Use a Query Object for liked posts to keep controller slim and to execute the work in the DB
  @liked_posts = LikedPostsQuery.new(current_account).call
    # The view will render the appropriate section based on @tab
  end

  private

  def set_post
    @post = Post.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to root_path, alert: 'Допис не знайдено.'
  end

  def post_params
    # Make sure to permit :image for uploading photos
    params.require(:post).permit(:body, :image)
  end
end
