class DummyArticlesController < ApplicationController
  before_action :set_dummy_article, :authorize_anonymous_access, only: %i[show]

  def show; end

  private

    def set_dummy_article
      @dummy_article = DummyArticle.find(params[:id])
    end
end
