module AnonymousAuthorization
  class AccessCodeService
    attr_reader :resource

    def initialize(resource)
      @resource = resource
    end

    def perform
      if resource.respond_to?(:anonymous_access_code)
        resource.anonymous_access_code
      else
        AccessCode.find_or_create_by(accessible: resource).code
      end
    end
    alias_method :access_code, :perform

    def current_code
      if resource.respond_to?(:anonymous_access_code)
        resource.anonymous_access_code
      else
        AccessCode.find_by(accessible: resource)&.code
      end
    end

    def authorize?(code)
      current_code == code&.strip
    end
  end
end
