Rails.application.routes.draw do

  #ゲストログイン
  devise_scope :user do
    post 'users/guest_sign_in', to: 'public/sessions#guest_sign_in'
  end
  #

  namespace :public do
    get 'relationships/followings'
    get 'relationships/followers'
  end
  devise_for :users,controllers:{
    registrations: 'public/registrations',
    sessions: 'public/sessions'
  }

  scope module: :public do
    resources :users, only:[:show, :edit, :update, :index] do
      member do
        get :favorites
      end
    end
    resources :posts do
      resources :post_comments, only:[:create, :destroy]
      resource :favorites, only:[:create, :destroy]
        member do
          get :favorites
        end
    end
    #フォロー機能
    resources :users do
      resource :relationships, only:[:create, :destroy]
      get 'followings' => 'relationships#followings', as: 'followings'
      get "followers" => "relationships#followers", as: "followers"
    end
    #検索機能
    get "search"
  end

  # 退会確認画面
  get "/users/unsubscribe" => "public/users#unsubscribe", as: "unsubscribe"
  # 論理削除用のルーティング
  patch "/users/withdrawal" => "public/users#withdrawal", as: "withdrawal"

  devise_for :admin,skip:[:registrations,:passwords],controllers:{
    sessions:'admin/sessions'
  }
  namespace :admin do
    get "/" => "homes#top"
    resources :users, only: [:index, :show, :edit, :update]
  end

  root 'public/homes#top'
  get 'about' => 'public/homes#about'


  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
