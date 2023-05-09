module AnonymousAuthorization
  class AccessSessionService
    attr_reader :session_id

    def initialize(session_id)
      @session_id = session_id
    end

    def authorize(resource, expires_in: 1.day)
      AccessCodeService.new(resource).access_code
        .tap { |code| cache.write(cache_key(resource), code, expires_in:) }
    end

    def authorized?(resource)
      cache.read(cache_key(resource))&.then do |cached_code|
        cached_code == AccessCodeService.new(resource).current_code
      end
    end

    private

      def cache
        @cache ||= Rails.cache
      end

      def cache_key(resource)
        "anon_access:session:#{session_id}:resource:#{Digest::MD5.hexdigest(resource.to_gid.to_s)}"
      end
  end
end
