module AnonymousAuthorization
  class AccessSessionService
    InvalidSessionId = Class.new StandardError

    attr_reader :session_id

    def initialize(session_id)
      @session_id = session_id

      raise InvalidSessionId, "should use valid session id" if @session_id.blank?
    end

    def authorize(resource, expires_at: 1.day.from_now)
      AccessCodeService.new(resource).access_code
        .tap { |code| cache.write(cache_key(resource), code, expires_at:) }
    end

    def authorized?(resource)
      cache.read(cache_key(resource))&.then do |cached_code|
        cached_code == AccessCodeService.new(resource).current_code
      end
    end

    def clear(resource)
      cache.delete(cache_key(resource))
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
