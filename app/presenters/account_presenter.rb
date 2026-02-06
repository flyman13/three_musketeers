class AccountPresenter
  attr_reader :account

  def initialize(account)
    @account = account
  end

  def username
    account.username
  end

  def display_name
    # If you later add a separate display name field, prefer it here
    account.username
  end

  def bio
    account.description
  end

  # expose account for views that expect @profile.account
  def to_model
    account
  end

  # allow calling .account from the presenter
  def account
    @account
  end
end
