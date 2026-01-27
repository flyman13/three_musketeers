Rails.application.routes.draw do
  root "posts#index"

  get 'my_profile', to: 'posts#my_profile', as: 'my_profile'

  # Переконайся, що тут є і :new, і :create
  resources :posts, only: [:index, :new, :create, :show, :destroy] do
    member do
      post :like
      get :delete
    end

    # Ось тут ми вкладаємо лайки в коментарі
    resources :comments, only: [:create, :destroy] do
      member do
        post :like   # Це створить той самий like_post_comment_path
        get :delete
      end
    end
  end

  # Маршрути для авторизації (вхід/вихід)
  get    'login',  to: 'sessions#new'     # Сторінка з формою
  post   'login',  to: 'sessions#create'  # Процес перевірки пароля
  
  # Вихід із системи (підтримуємо обидва методи для надійності)
  delete 'logout', to: 'sessions#destroy'
  get    'logout', to: 'sessions#destroy'

  # Реєстрація нових мушкетерів
  resources :accounts, only: [:new, :create]

  # Профілі (якщо вони знадобляться Владу для дизайну)
  resources :user_profiles, controller: 'profiles', as: 'user_profile', only: [:show]

  
end