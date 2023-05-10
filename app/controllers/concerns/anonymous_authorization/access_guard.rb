module AnonymousAuthorization
  module AccessGuard
    extend ActiveSupport::Concern

    InvalidResourceGid = Class.new(StandardError)

    private

      def authorize_anonymous_access(resource, redirect_url: nil, name: nil)
        return if AccessSessionService.new(session.id).authorized?(resource)

        redirect_to anonymous_authorization.new_authorization_path \
          redirect_url: (redirect_url || request.url),
          resource_gid: resource.to_gid.to_param,
          resource_name: name
      end
  end
end
