Rails.application.routes.draw do
  resources :users, only: [:new, :create] do
    post "password", on: :member
  end
  resource :session, only: [:new, :create, :destroy]
  resources :cats
  resources :cat_rental_requests do
    post "approve", on: :member
    post "deny", on: :member
  end
end
