AnonymousAuthorization::Engine.routes.draw do
  get "welcome/index"
  root "welcome#index"

  resources :authorizations, only: %i[new create]
end
