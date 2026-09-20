Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :jobs, only: [:index, :show, :create, :update, :destroy]
      resources :tags, only: [:index, :show, :create, :update, :destroy]
      resources :resumes, only: [:index, :show, :create, :update, :destroy]
      resources :jobs_tags, only: [:index, :create, :destroy]
      resource :stats, only: [:show]

      post "/signup", to: "users#create"
      get "/profile", to: "users#profile"

      post "/login", to: "auth#login"
      get "/auto_login", to: "auth#auto_login"
    end
  end
end
