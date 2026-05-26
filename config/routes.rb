Rails.application.routes.draw do
  devise_for :users, controllers: {
    registrations: "registrations",
    sessions: "sessions",
    omniauth_callbacks: "omniauth_callbacks"
  }
  root "tops#index"
  get "home", to: "homes#index"
  get "home/autocomplete", to: "homes#autocomplete", as: :autocomplete_home
  get "guide", to: "guides#index"
  get "reframing", to: "reframings#index"
  post "reframing/finish", to: "reframings#finish_onboarding", as: :finish_onboarding
  get "reviews", to: "reviews#index"
  get "terms", to: "pages#terms"
  get "privacy", to: "pages#privacy"
  get "contact", to: "contacts#new"
  post "contact", to: "contacts#create"
  get "settings", to: "settings#index"
  patch "settings", to: "settings#update"
  get "calendar", to: "calendars#index"

  resources :habits do
    resources :habit_checks, only: [ :new, :create, :edit, :update ]
    resources :reviews, only: [ :show ]
  end

  if Rails.env.development?
    mount LetterOpenerWeb::Engine, at: "/letter_opener"
  end
end
