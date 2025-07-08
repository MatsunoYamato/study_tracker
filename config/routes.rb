Rails.application.routes.draw do
  devise_for :users
  
  # ログイン後はダッシュボードにリダイレクト
  authenticated :user do
    root 'study_sessions#dashboard', as: :authenticated_root
  end
  
  # 未ログイン時はホーム画面
  root 'home#index'
  
  # 学習記録のRESTfulルート
  resources :study_sessions do
    member do
      patch :quick_record  # ポモドーロ用クイック記録
    end
  end
  
  # ダッシュボード
  get 'dashboard', to: 'study_sessions#dashboard'
  
  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get 'up' => 'rails/health#show', as: :rails_health_check
end
