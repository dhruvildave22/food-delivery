# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.4.4'

gem 'bcrypt'
gem 'bootsnap', '>= 1.1.0', require: false
gem 'highline'
gem 'pg', '~> 1.2.3'
gem 'puma', '~> 5.5'
gem 'rack-cors'
gem 'rails', '~> 5.2.3'
gem 'rubocop'

group :development do
  gem 'listen', '>= 3.0.5', '< 3.2'
end

group :test do
  gem 'factory_bot_rails'
  gem 'faker'
  gem 'rspec-rails'
  gem 'shoulda-matchers'
  gem 'simplecov'
  gem 'timecop'
end
