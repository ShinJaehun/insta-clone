Rails.application.routes.draw do
  devise_for :users, controllers: { registrations: 'users/registrations' }
  root 'posts#index'
  resources :posts do
    post 'like', to: 'posts#like', as: :like, on: :member
    # posts/:post_id/like  member를 붙이지 않으면
    # posts/:id/like member를 붙이면...
    # as는 주소의 별칭... 
    # like_post_path라는 별칭이 생긴다...
  end
  
  #resources :posts do
  #  resources :comments
  #end
  # comments#show 
  # posts/:post_id/comments/:id
  
  # get 'mypage', to: 'posts#mypage'
  resources :users, only:[:show] do
    post 'follow', to: 'users#follow', as: :follow, on: :member
  end
end
