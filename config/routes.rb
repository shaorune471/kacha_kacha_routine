Rails.application.routes.draw do
  devise_for :users, controllers: {
    registrations: "registrations",
    sessions: "sessions"
  }
  root "tops#index"
  get "home", to: "homes#index"
  get "reframing", to: "reframings#index"

  resources :habits do
    resources :habit_checks, only: [ :new, :create ]
  end
end
