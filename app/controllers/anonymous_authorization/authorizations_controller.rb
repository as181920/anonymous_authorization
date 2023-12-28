module AnonymousAuthorization
  class AuthorizationsController < ApplicationController
    before_action :set_resource, :ensure_resource_presence, only: %i[new create]

    after_action :clear_redirect_session, only: [:create]

    def new
      session[:redirect_url] = params[:redirect_url] || request.referer
    end

    def create
      redirect_url = authorization_params[:redirect_url] || session[:redirect_url] || request.referer || root_path

      if AccessCodeService.new(@resource).authorize?(authorization_params[:access_code])
        AccessSessionService.new(session.id).authorize(@resource, expires_at: authorization_params[:expires_at].presence)
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

      def clear_redirect_session
        session.delete(:redirect_url) if session[:redirect_url].present?
      end
  end
end
