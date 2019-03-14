class ActionDispatch::Routing::Mapper
  def draw routes_name
    instance_eval(File.read(Rails.root.join("config/routes/#{routes_name}.rb")))
  end
end

Rails.application.routes.draw do
  devise_for :users, only: :omniauth_callbacks, controllers: {omniauth_callbacks: "users/omniauth_callbacks"}
  draw :api
  mount ActionCable.server, at: "/cable"
  scope "(:locale)", locale: /en|vi/ do
    root "home#index"
    post "/newcomment", to: "courses#newcomment", as: "newcomment"
    post "/walletcode", to: "users#update_wallet", as: "update_wallet"
    delete "/cart_items", to: "cart_items#destroy_cart_item_not_login", as: "destroy_cart_item_not_login"
    resources :search, only: :index
    resources :categories, only: :show
    resources :courses do
      resources :lessons
    end
    resources :comments, only: :update
    resources :cart_items
    resources :orders, only: %i(index create)
    devise_for :users, controllers: { registrations: "users/registrations", sessions: "users/sessions",
    passwords: "users/passwords"}, skip: :omniauth_callbacks
    resources :users, only: :show do
      member do
        get :following, :followers
      end
    end
    resources :relationships, only: [:create, :destroy]
    resources :transactions, only: %i(new create update)

    namespace :admin do
      resources :credits, only: [:update, :index, :show]
      resources :users
      resources :categories
      resources :giftcodes, only: :index
      resources :courses do
        resources :lessons
      end
      get "/", to: "dashboards#index"
    end

    resources :e_wallets, only: [:create, :show]
    resources :credits, only: [:update, :new, :create]
    resources :payings, only: [:new, :create, :update]
  end
end
