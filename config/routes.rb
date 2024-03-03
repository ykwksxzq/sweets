Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
# 顧客用
# URL /users/sign_in ...
devise_for :users,skip: [:passwords], controllers: {
  registrations: "public/registrations",
  sessions: 'public/sessions'
}

# 管理者用
# URL /admin/sign_in ...
devise_for :admin, skip: [:registrations, :passwords] ,controllers: {
  sessions: "admin/sessions"
}

namespace :admin do
  get 'top' => 'homes#top', as: ''
  resources :genres, only: [:index, :create, :edit, :update, :destroy]
end

#ゲストログイン用

get "users" => redirect("/users/sign_up")

devise_scope :user do
  post 'users/guest_sign_in', to: 'public/sessions#guest_sign_in'
end




scope module: :public do
  root to: "homes#top"

  get 'users/mypage/:id' => 'users#show', as: 'mypage'

  resources :posts, only: [:new, :index, :show, :create, :edit, :update, :destroy]
end

end
