require_relative "lib/anonymous_authorization/version"

Gem::Specification.new do |spec|
  spec.name        = "anonymous_authorization"
  spec.version     = AnonymousAuthorization::VERSION
  spec.authors     = ["Andersen Fan"]
  spec.email       = ["as181920@gmail.com"]
  spec.homepage    = "https://github.com/as181920/anonymous_authorization"
  spec.summary     = "Enable anonymous authorization for resource by access code"
  spec.description = "Extracting common functionality for anonymous authorization to resource."
  spec.license     = "MIT"
  spec.required_ruby_version = ">= 3.1"

  spec.metadata["allowed_push_host"] = "https://gems.dd-life.com"
  spec.metadata["rubygems_mfa_required"] = "true"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/as181920/anonymous_authorization"
  spec.metadata["changelog_uri"] = "https://github.com/as181920/anonymous_authorization"

  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]
  end

  spec.add_dependency "pundit"
  spec.add_dependency "rails", ">= 7.0"
end
