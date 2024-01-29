require "anonymous_authorization/version"

module AnonymousAuthorization
  def self.table_name_prefix
    "anon_"
  end
end

require "anonymous_authorization/engine"
