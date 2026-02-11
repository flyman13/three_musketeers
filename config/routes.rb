Rails.application.routes.draw do
  root "posts#index"

  get 'my_profile', to: 'posts#my_profile', as: 'my_profile'

  # Make sure :new and :create are present here
  resources :posts, only: [:index, :new, :create, :show, :destroy] do
    member do
      post :like
      post :save
      delete :unsave
      get :delete
    end

  # Here we nest likes under comments
    resources :comments, only: [:create, :destroy] do
      member do
        post :like   # This will create the same like_post_comment_path
        delete :unlike
      end
    end
  end

  # Routes for authentication (login/logout)
  get    'login',  to: 'sessions#new'     # Page with the form
  post   'login',  to: 'sessions#create'  # Password authentication process

  # Logout routes (support both methods for reliability)
  delete 'logout', to: 'sessions#destroy'
  get    'logout', to: 'sessions#destroy'

  # Routes for account registration
  # Corrected routes structure
  resources :accounts, only: [:new, :create, :show] do
    collection do
      get :search # Route for the search functional
    end
    member do
      get :following, :followers
    end
  end

  # Profile routes (kept in case Vlad needs them for design)
  resources :user_profiles, controller: 'profiles', as: 'user_profile', only: [:show]

  # Routes for profile management
  resource :profile, only: [:edit, :update]

  # Routes for social interactions
  resources :relationships, only: [:create, :destroy]

  resources :reactions, only: [:create, :destroy]

  get 'set_theme', to: 'theme#update'

end