require_relative "boot"

require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)
require "anonymous_authorization"

module Dummy
  class Application < Rails::Application
    config.before_configuration do
      env_file = Rails.root.join("config/local_env.yml")
      if File.file?(env_file)
        YAML.load_file(env_file, aliases: true)[Rails.env].to_h.each do |key, value|
          ENV[key.to_s] = value.to_s
        end
      end
    end

    config.load_defaults Rails::VERSION::STRING.to_f

    # For compatibility with applications that use this config
    config.action_controller.include_all_helpers = false

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")
    config.time_zone = "Beijing"
    config.i18n.available_locales = %i[zh-CN en]
    config.i18n.default_locale = :"zh-CN"
    config.i18n.fallbacks = {
      CN: :"zh-CN",
      "zh-HK": :"zh-CN",
      "zh-TW": :"zh-CN",
      "en-US": :en,
      "en-BG": :en,
      "en-CA": :en,
      "en-AU": :en
    }

    config.action_mailer.smtp_settings = {
      address: ENV.fetch("action_mailer_smtp_address", nil),
      port: ENV.fetch("action_mailer_smtp_port", nil),
      domain: ENV.fetch("action_mailer_smtp_domain", nil),
      user_name: ENV.fetch("action_mailer_smtp_user_name", nil),
      password: ENV.fetch("action_mailer_smtp_password", nil),
      authentication: "plain"
    }
    config.action_mailer.preview_path = "#{AnonymousAuthorization::Engine.root}/test/mailers/previews"
  end
end
