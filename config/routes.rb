Rails.application.routes.draw do
  devise_for :users, only: :omniauth_callbacks, controllers: {omniauth_callbacks: "users/omniauth_callbacks"}
  scope "(:locale)", locale: /en|vi/ do
    root "home#index"
    devise_for :users, controllers: { registrations: "users/registrations", sessions: "users/sessions",
    passwords: "users/passwords"}, skip: :omniauth_callbacks

    namespace :admin do
      resources :users
      get "/dashboards", to: "dashboards#index"
    end
  end
end
