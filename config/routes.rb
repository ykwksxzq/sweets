Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
# 顧客用
# URL /users/sign_in ...
devise_for :users,skip: [:passwords], controllers: {
  registrations: 'public/registrations',
  sessions: 'public/sessions'
}

# 管理者用
# URL /admin/sign_in ...
devise_for :admin, skip: [:registrations, :passwords] ,controllers: {
  sessions: 'admin/sessions'
}

namespace :admin do
  get 'top' => 'homes#top', as: ''
  resources :genres, only: [:index, :create, :edit, :update, :destroy]
  resources :users, only: [:index, :show, :edit, :update]
  resources :posts, only: [:index, :show ] do
    resources :comments, only: [:destroy]
    resources :reviews, only: [:destroy]
  end
  resources :comments, only: [:index]
  resources :reviews, only: [:index, :show]
end

#ゲストログイン用

get 'users' => redirect('/users/sign_up')

devise_scope :user do
  post 'users/guest_sign_in', to: 'public/sessions#guest_sign_in'
end


scope module: :public do
  root to: 'homes#top'

  get 'posts/confirm' => 'posts#confirm', as: 'post_confirm'
  get 'search_tag'=>'posts#search_tag'
  get 'users/mysweets' => 'users#mysweets', as: 'mysweets'
  get 'users/myreviews' => 'users#myreviews', as: 'myreviews'
  get 'users/myfavorites' => 'users#myfavorites', as: 'myfavorites'
  get 'users/unsubscribe' => 'users#unsubscribe', as: 'confirm_unsubscribe'
  get 'users/mypage/:id' => 'users#show', as: 'mypage'

  resources :genres, only:[:index]
  resources :users, only: [:create, :edit, :update, :destroy] do
    resource :relationships, only: [:create, :destroy]
     get "followings" => "relationships#followings", as: "followings"
     get "followers" => "relationships#followers", as: "followers"
  end
  resources :posts, only: [:new, :index, :show, :create, :edit, :update, :destroy] do
   resource :favorite, only: [:create, :destroy]
   resources :comments, only: [:create, :destroy]
   resources :reviews, only: [:index, :create, :destroy]
  end
end

end