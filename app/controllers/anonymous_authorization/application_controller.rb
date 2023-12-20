module AnonymousAuthorization
  class ApplicationController < ActionController::Base
    protect_from_forgery with: :null_session

    helper EasyStyle::Engine.helpers
  end
end
