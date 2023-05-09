require "anonymous_authorization/version"
require "anonymous_authorization/engine"

module AnonymousAuthorization
  def self.table_name_prefix
    "anon_"
  end
end
