module AnonymousAuthorization
  class AuthorizationsController < ApplicationController
    before_action :set_authorization, only: %i[ show edit update destroy ]

    # GET /authorizations
    def index
      @authorizations = Authorization.all
    end

    # GET /authorizations/1
    def show
    end

    # GET /authorizations/new
    def new
      @authorization = Authorization.new
    end

    # GET /authorizations/1/edit
    def edit
    end

    # POST /authorizations
    def create
      @authorization = Authorization.new(authorization_params)

      if @authorization.save
        redirect_to @authorization, notice: "Authorization was successfully created."
      else
        render :new, status: :unprocessable_entity
      end
    end

    # PATCH/PUT /authorizations/1
    def update
      if @authorization.update(authorization_params)
        redirect_to @authorization, notice: "Authorization was successfully updated."
      else
        render :edit, status: :unprocessable_entity
      end
    end

    # DELETE /authorizations/1
    def destroy
      @authorization.destroy
      redirect_to authorizations_url, notice: "Authorization was successfully destroyed."
    end

    private
      # Use callbacks to share common setup or constraints between actions.
      def set_authorization
        @authorization = Authorization.find(params[:id])
      end

      # Only allow a list of trusted parameters through.
      def authorization_params
        params.fetch(:authorization, {})
      end
  end
end
