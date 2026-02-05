class AccountsController < ApplicationController
  def new
    @account = Account.new
  end

  def create
    @account = Account.new(account_params)
    if @account.save
      session[:account_id] = @account.id
      redirect_to root_path, notice: "Акаунт створено!"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def show
    # Find the account by ID from the URL params
    @account = Account.find(params[:id])
    @posts = @account.posts.order(created_at: :desc)
    
    # English comment: Loading user data and their posts for the show view
  end

  def following
    @account = Account.find(params[:id])
    @accounts = @account.following
    render 'show_follow' # We will use one view for both lists
  end

  def followers
    @account = Account.find(params[:id])
    @accounts = @account.followers
    render 'show_follow'
  end

  def search
    if params[:username].present?
      # Search for accounts where username is similar to the query
      @accounts = Account.where("username LIKE ?", "%#{params[:username]}%")
    else
      @accounts = Account.none
    end
  end

  private

  def account_params
    params.require(:account).permit(:username, :email, :password, :password_confirmation)
  end
end