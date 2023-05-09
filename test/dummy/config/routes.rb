Rails.application.routes.draw do
  mount AnonymousAuthorization::Engine => "/anonymous_authorization"
end
