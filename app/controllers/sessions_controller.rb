class SessionsController < ApplicationController
  def new
    # Just renders the login form page
  end

  def create
  account = Account.find_by(email: params[:email])
  
  # authenticate is provided by the bcrypt gem
  if account && account.authenticate(params[:password])
    session[:account_id] = account.id
    redirect_to root_path, notice: "З поверненням!"
  else
    # If the password is incorrect, return to the form
    flash.now[:alert] = "Невірний email або пароль"
    render :new, status: :unprocessable_entity
  end
end

  def destroy
    # Clear the session to log out
    session[:account_id] = nil
    redirect_to root_path, notice: "Ви вийшли з акаунта."
  end
end