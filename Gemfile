source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

# Specify your gem's dependencies in anonymous_authorization.gemspec.
gemspec

gem "debug"
gem "rubocop"
gem "rubocop-erb"
gem "rubocop-minitest"
gem "rubocop-rails-omakase"
gem "rubocop-rake"

gem "guard"
gem "guard-bundler"
gem "guard-minitest"
gem "guard-rubocop"
gem "minitest"
gem "minitest-reporters"

gem "pg"
gem "propshaft"
gem "puma"

gem "easy_style", git: "git@gitlab.dd-life.com:corp.front_end/easy_style_engine.git", branch: "main"

group :test do
  gem "capybara"
  gem "factory_bot_rails"
  gem "mocha"
  gem "selenium-webdriver"
  gem "webmock"
end
