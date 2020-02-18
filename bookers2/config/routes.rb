Rails.application.routes.draw do
    root to: 'homes#index'
    get 'homes/show' => 'homes#show', as: 'home_about'
    devise_for :users
    resources :users
    resources :books
    delete 'books/:id' => 'books#destroy', as: 'destroy_book'
end
