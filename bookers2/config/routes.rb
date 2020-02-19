Rails.application.routes.draw do
    root to: 'homes#index'
    resources :homes, only: [:show]
    devise_for :users
    resources :users
    resources :books
    delete 'books/:id' => 'books#destroy', as: 'destroy_book'
end
