class ApplicationController < ActionController::Base
  # helper_method allows Vlad and Vova to use this method in views
  helper_method :current_account

  private

  def current_account
    # Find the account by ID from the session if present
    # @current_account ||= — a built-in pattern to avoid querying the DB twice (memoization)
    @current_account ||= Account.find_by(id: session[:account_id]) if session[:account_id]
  end
end