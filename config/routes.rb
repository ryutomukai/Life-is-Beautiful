Rails.application.routes.draw do

  devise_for :users,controllers:{
    registrations: 'public/registrations',
    sessions: 'public/sessions'
  }

  scope module: :public do
  resources :users, only:[:show, :edit, :update]
  resources :posts do
    resources :post_comments, only:[:create, :destroy]
    resource :favorites, only:[:create, :destroy]
    end
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
