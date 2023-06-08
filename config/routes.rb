Rails.application.routes.draw do
  root :to =>"homes#top"
  get "home/about"=>"homes#about"
  # devise関連のルーティングは、他のルーティングよりも前に記述する必要がある（競合を避けるため）
  # usersのdevise routes
  devise_for :users
  # userにゲストログイン機能を追加するためのルーティング
  devise_scope :user do
    post 'users/guest_sign_in', to: 'users/sessions#guest_sign_in'
  end
  # adminsのdevise routes
  devise_for :admins, skip: :registrations

  # 本関連のルーティング
  resources :books, only: [:index,:show,:edit,:create,:destroy,:update] do
    resource :favorites, only: [:create, :destroy]
    resources :book_comments, only: [:create, :destroy]
  end

  # ユーザー関連のルーティング
  resources :users, only: [:index,:show,:edit,:update] do
    member do
      get :following, :followers
    end
    resources :direct_messages, only: [:index, :create]
  end
  resources :relationships, only: [:create, :destroy]
  resources :groups, except: :destroy do
    resource :group_users, only: [:create, :destroy]
    resources :group_messages, only: [:new, :create, :show, :index]
  end
  # お天気情報のルーティング
  get 'weather_info/show'
  get "search"=>'searches#search'
  # タグ検索も検索のカテゴリ選択に含めれば良さそうだが、今回は教材の見た目通りに実装する
  get "tag_search"=>'tag_searches#search'

  # 管理者関連のルーティング
  namespace :admins do
    get 'dashboard', to: 'admins#dashboard'
    get 'users', to: 'admins#users'
    resources :admins, only: [:new, :create, :destroy]
  end
end
