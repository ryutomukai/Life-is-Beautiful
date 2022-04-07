Rails.application.routes.draw do

  # namespace :public do
  #   get 'users/index'
  #   get 'users/show'
  #   get 'users/edit'
  # end

  devise_for :users,controllers:{
    registrations: 'public/registrations',
    sessions: 'public/sessions'
  }

  resource :users, only:[:show, :edit, :update]
  # 退会確認画面
  get "/users/unsubscribe" => "public/users#unsubscribe", as: "unsubscribe"
  # 論理削除用のルーティング
  patch "/users/withdrawal" => "public/users#withdrawal", as: "withdrawal"

  devise_for :admins,skip:[:registrations,:passwords],controllers:{
    sessions:'admin/sessions'
  }

  root 'public/homes#top'
  get 'about' => 'public/homes#about'

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
