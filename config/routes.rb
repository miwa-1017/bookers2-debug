Rails.application.routes.draw do

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
    devise_for :users
    root to: "homes#top"
    get "home/about"=>"homes#about"

  resources :books do
    resources :book_comments, only: [:create, :destroy]
    resource :favorites, only: [:create, :destroy]
  end
  resources :users, only: [:index, :show, :edit, :update] do
    resource :relationships,only: [:create, :destroy]
    get 'followings' => 'users#followings', as: 'followings'
    get 'followers' => 'users#followers', as: 'followers'
  end
   get "search" => "searches#search"
   get 'search_tag' => 'books#search_tag'
    
end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

