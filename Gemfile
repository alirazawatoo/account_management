source "https://rubygems.org"

ruby file: ".ruby-version"

gem "rails", "~> 8.1.0"
gem "sqlite3", ">= 2.1"
gem "puma", ">= 6.4"
gem "bootsnap", require: false
gem "active_model_serializers", "~> 0.10.15"

group :development, :test do
  gem "debug", platforms: %i[mri windows], require: "debug/prelude"
  gem "faker"
  gem "factory_bot_rails"
  gem "rspec-rails"
  gem "shoulda-matchers"
  gem "simplecov", require: false
  gem "rubocop-rails-omakase", require: false
  gem "bundler-audit", require: false
end

gem "tzinfo-data", platforms: %i[windows jruby]
