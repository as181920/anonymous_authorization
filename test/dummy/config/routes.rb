Rails.application.routes.draw do
  resources :dummy_articles
  mount AnonymousAuthorization::Engine => "/anonymous_authorization"
end
