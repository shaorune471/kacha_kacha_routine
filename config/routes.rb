Rails.application.routes.draw do
  root "tops#index"
  get "reframing", to: "reframings#index"
end
