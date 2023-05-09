module AnonymousAuthorization
  class WelcomeController < ApplicationController
    def index
      render layout: false
    end
  end
end
