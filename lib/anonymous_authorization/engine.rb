require "pundit"

module AnonymousAuthorization
  class Engine < ::Rails::Engine
    isolate_namespace AnonymousAuthorization

    initializer :append_migrations do |app|
      unless app.root == root.join("test/dummy")
        config.paths["db/migrate"].expanded.each do |expanded_path|
          app.config.paths["db/migrate"] << expanded_path
        end
      end
    end

    initializer "anonymous_authorization.assets.precompile" do |app|
      app.config.assets.precompile += %w[
        anonymous_authorization_manifest.js
      ]
    end

    config.to_prepare do
      Dir.glob(AnonymousAuthorization::Engine.root.join("app/extensions/**/*_extension*.rb")).each do |c|
        require_dependency c
      end
    end

    config.generators do |g|
      g.orm             :active_record
      g.template_engine :erb
      g.stylesheets     false
      g.javascripts     false
      g.helper          false
      g.test_framework  :test_unit
      g.skip_routes     true
    end
  end
end
