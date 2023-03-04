Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  devise_for :users
  root to:"homes#top"
  get "home/about"=>"homes#about"
  get "search" => "searches#search"
  resources :users, only: [:index,:show,:edit,:update] do
    resource :relationships, only: [:create, :destroy]
    get 'followings' => 'relationships#followings', as: 'followings'
    get 'followers' => 'relationships#followers', as: 'followers'
    get 'search_date' => 'users#search_date'
    resources :messages, only: [:create]
    resources :rooms, only: [:create, :index, :show]
  end
  resources :books, only: [:index,:show,:edit,:create,:destroy,:update,:new] do
    resource :favorites, only: [:create, :destroy]
    resources :post_comments, only: [:create,:destroy]
  end


  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
