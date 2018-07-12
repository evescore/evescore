# frozen_string_literal: true

source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?('/')
  "https://github.com/#{repo_name}.git"
end

gem 'bootstrap-sass', '~> 3.3.6'
gem 'capistrano'
gem 'capistrano-rails'
gem 'coffee-rails', '~> 4.2'
gem 'daemons'
gem 'delayed_job_mongoid'
gem 'devise'
gem 'devise-bootstrapped'
gem 'haml-rails'
gem 'jquery-rails'
gem 'kaminari'
gem 'kaminari-mongoid'
gem 'mongoid'
gem 'omniauth-crest'
gem 'passenger'
gem 'puma', '~> 3.7'
gem 'rails', '~> 5.1.4'
gem 'ruby-esi', '~> 0.2'
gem 'sass-rails', '~> 5.0'
gem 'tqdm'
gem 'turbolinks', '~> 5'
gem 'uglifier', '>= 1.3.0'
gem 'whenever', require: false

group :test do
  gem 'database_cleaner'
  gem 'factory_bot_rails'
  gem 'simplecov', require: false
  gem 'vcr'
  gem 'webmock'
end

group :development, :test do
  gem 'awesome_print'
  gem 'capybara', '~> 2.13'
  gem 'launchy'
  gem 'poltergeist'
  gem 'pry-rails'
  gem 'rspec-rails'
end

group :development do
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'letter_opener'
  gem 'rubocop'
  gem 'spring'
end
