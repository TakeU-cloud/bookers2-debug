Rails.application.routes.draw do
  get 'group_messages/new'
  get 'group_messages/create'
  get 'group_messages/show'
  get 'direct_messages/index'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  devise_for :users

  root :to =>"homes#top"
  get "home/about"=>"homes#about"

  get "search"=>'searches#search'
  # タグ検索も検索のカテゴリ選択に含めれば良さそうだが、今回は教材の見た目通りに実装する
  get "tag_search"=>'tag_searches#search'

  resources :books, only: [:index,:show,:edit,:create,:destroy,:update] do
    resource :favorites, only: [:create, :destroy]
    resources :book_comments, only: [:create, :destroy]
  end
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
  devise_scope :user do
    post 'users/guest_sign_in', to: 'users/sessions#guest_sign_in'
  end
end
