Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/*
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest

  # Defines the root path route ("/")
  # root "posts#index"

  # procuct
  # delete "/products/:id", to: "products#destroy"
  # patch "/products/:id", to: "products#update"
  # post "/products", to: "products#create"
  # get "/products/new", to: "products#new", as: :new_product
  # get "/products", to: "products#index"
  # get "/products/:id", to: "products#show", as: :product
  # get "/products/:id/edit", to: "products#edit", as: :edit_product
  # This content the above routes:

  namespace :authentication, path: "", as: "" do
    resources :users, only: %i[new create], path: "/register",  path_names: { new: "/" }
    resources :sessions, only: %i[new create destroy], path: "/login", path_names: { new: "/" }
  end

  resources :favorites, only: %i[ index create destroy ], param: :product_id
  resources :users, only: :show, path: "/user", param: :username
  resources :categories, except: :show
  resources :products, path: "/"
end
