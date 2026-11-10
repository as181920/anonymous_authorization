module AnonymousAuthorization
  class AuthorizationsController < ApplicationController
    before_action :set_resource, :ensure_resource_presence, only: %i[new create]

    def new
      @redirect_url = params[:redirect_url] || request.referer
    end

    def create
      redirect_url = authorization_params[:redirect_url] || request.referer || root_path

      if AccessCodeService.new(@resource).authorize?(authorization_params[:access_code])
        AuthorizationSession.new(session:).authorize(@resource, expires_at: authorization_params[:expires_at].presence)
        redirect_to redirect_url
      else
        redirect_to redirect_url, alert: I18n.t("anonymous_authorization.invalid_access_code")
      end
    end

    private

      def set_resource
        @resource = (params.dig(:authorization, :resource_gid) || params[:resource_gid])
          &.then { |resource_gid| GlobalID::Locator.locate resource_gid }
      end

      def ensure_resource_presence
        return if @resource.present?

        render :invalid_resource
      end

      def authorization_params
        params.fetch(:authorization, {}).permit :resource_gid, :access_code, :expires_at, :redirect_url
      end
  end
end
