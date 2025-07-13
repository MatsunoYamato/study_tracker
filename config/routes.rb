Rails.application.routes.draw do
  devise_for :users, controllers: {
    registrations: 'users/registrations'
  }

  # ログイン後はダッシュボードにリダイレクト
  authenticated :user do
    root 'study_sessions#dashboard', as: :authenticated_root
  end

  # 未ログイン時はホーム画面
  root 'home#index'

  # 学習記録のRESTfulルート
  resources :study_sessions do
    collection do
      patch :quick_record # ポモドーロ用クイック記録
    end
  end

  # タグ管理のRESTfulルート
  resources :tags

  # ポモドーロタイマー
  get 'pomodoro', to: 'pomodoro#index'
  post 'pomodoro/save_session', to: 'pomodoro#save_session'

  # ダッシュボード
  get 'dashboard', to: 'study_sessions#dashboard'
  get 'dashboard_test', to: 'study_sessions#dashboard_test'

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get 'up' => 'rails/health#show', as: :rails_health_check
end
