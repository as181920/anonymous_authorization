class DummyArticlesController < ApplicationController
  include AnonymousAuthorization::AccessGuard

  before_action :set_dummy_article, only: %i[show]

  before_action -> { authorize_anonymous_access(@dummy_article, name: @dummy_article.name) }, only: %i[show]

  def show
    render plain: "FILLER CONTENT"
  end

  private

    def set_dummy_article
      @dummy_article = DummyArticle.find(params[:id])
    end
end
