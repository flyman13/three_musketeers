class PostsController < ApplicationController
  before_action :set_post, only: [:show, :destroy, :delete, :like]

  def index
    @posts = Post.includes(:account, :comments, :reactions).all.order(created_at: :desc)
  end

  def show
    # @post вже знайдено через set_post
  end

  def new
    @post = current_account.posts.build
  end

  def create
    @post = current_account.posts.build(post_params)
    if @post.save
      redirect_to root_path, notice: "Пост створено!"
    else
      # status: :unprocessable_entity важливо для Rails 7, щоб форма показувала помилки
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
    # Знаходимо пости тільки поточного акаунта
    @posts = current_account.posts.order(created_at: :desc)

    # Використовуємо той самий файл відображення, що і для головної сторінки
    render :index 
  end

  private

  def set_post
    @post = Post.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to root_path, alert: "Допис не знайдено."
  end

  def post_params
    # Обов'язково дозволяємо :image для завантаження фото
    params.require(:post).permit(:body, :image)
  end

end