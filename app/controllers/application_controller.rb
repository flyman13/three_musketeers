class ApplicationController < ActionController::Base
  helper_method :current_account

  private

  def current_account
    @current_account ||= Account.find_by(id: session[:account_id]) if session[:account_id]
  end

  def require_login
    return if current_account
    redirect_to login_path, alert: "Будь ласка, увійдіть щоб виконати цю дію."
  end
end