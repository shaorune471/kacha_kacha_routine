Rails.application.routes.draw do
  devise_for :users, controllers: {
    registrations: "registrations",
    sessions: "sessions"
  }
  root "tops#index"
  get "home", to: "homes#index"
  get "guide", to: "guides#index"
  get "reframing", to: "reframings#index"
  post "reframing/finish", to: "reframings#finish_onboarding", as: :finish_onboarding
  get "reviews", to: "reviews#index"
  get "terms", to: "pages#terms"
  get "privacy", to: "pages#privacy"

  resources :habits do
    resources :habit_checks, only: [ :new, :create, :edit, :update ]
    resources :reviews, only: [ :show ]
  end
end
