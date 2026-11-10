require "digest"

module AnonymousAuthorization
  class AuthorizationSession
    def initialize(session:)
      @session = session
    end

    def authorize(resource, expires_at: nil)
      @session.update({}) if @session.id.nil?
      parsed_expires_at = ActiveModel::Type::DateTime.new.cast(expires_at) || 1.day.from_now
      AccessCodeService.new(resource).access_code.tap do |code|
        Rails.cache.write(cache_key(resource), code, expires_at: parsed_expires_at)
      end
    end

    def authorized?(resource)
      key = cache_key(resource)
      return false unless key

      code = Rails.cache.read(key)
      code.present? && code == AccessCodeService.new(resource).current_code
    end

    def clear(resource)
      key = cache_key(resource)
      Rails.cache.delete(key) if key
    end

    private

      def cache_key(resource)
        id = @session.id&.public_id
        "anon_auth:#{Digest::SHA256.hexdigest(id)}:#{resource.to_gid}" if id.present?
      end
  end
end
