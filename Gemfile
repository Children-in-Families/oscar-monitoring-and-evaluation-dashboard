source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.6.3'

gem 'rails',                    '~> 6.0.0'
gem 'pg',                       '>= 0.18', '< 2.0'
gem 'puma',                     '~> 3.11'
gem 'turbolinks',               '~> 5'
gem 'jbuilder',                 '~> 2.7'
gem 'image_processing',         '~> 1.2'
gem 'bootsnap',                 '>= 1.4.2', require: false

gem 'uglifier',                 '>= 1.3.0'
gem 'coffee-rails',             '~> 5.0'
gem 'bootstrap-sass',           '~> 3.3.5'
gem 'sass-rails',               '~> 5'
gem 'jquery-rails',             '~> 4.3', '>= 4.3.5'
gem 'font-awesome-rails',       '~> 4.7', '>= 4.7.0.5'
gem 'jquery-datatables-rails',  '~> 3.4'
gem 'bootstrap-datepicker-rails', '~> 1.8', '>= 1.8.0.1'
gem 'select2-rails',            '~> 4.0', '>= 4.0.3'
gem 'icheck-rails',             '~> 1.0', '>= 1.0.2.2'

gem 'haml',                     '~> 5.1', '>= 5.1.2'
gem 'haml-rails',               '~> 2.0', '>= 2.0.1'
gem 'simple_form',              '~> 4.1'
gem 'devise',                   '~> 4.7'
gem 'pundit',                   '~> 2.1'
gem 'kaminari',                 '~> 1.1', '>= 1.1.1'
gem 'browser',                  '~> 2.6', '>= 2.6.1'
gem 'paper_trail',              '~> 10.3', '>= 10.3.1'
gem 'paper_trail-association_tracking', '~> 2.0'
gem 'draper',                   '~> 3.1'

gem 'apartment', github: 'influitive/apartment', branch: 'development'

group :staging, :production do
  gem 'appsignal',                '~> 2.3', '>= 2.3.7'
  gem 'asset_sync',               '~> 2.8', '>= 2.8.1'
  gem 'fog-aws',                  '~> 3.5', '>= 3.5.2'
end

group :development, :test do
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  gem 'rspec-rails',            '~> 3.8', '>= 3.8.2'
  gem 'pry-rails',              '~> 0.3.9'
  gem 'factory_bot_rails',      '~> 5.0', '>= 5.0.2'
  gem 'capybara',               '~> 3.29'
  gem 'launchy',                '~> 2.4', '>= 2.4.3'
  gem 'poltergeist',            '~> 1.18', '>= 1.18.1'
  gem 'thin',                   '~> 1.7', '>= 1.7.2'
  gem 'ffaker',                 '~> 2.1.0'
end

group :development do
  gem 'web-console',            '>= 3.3.0'
  gem 'listen',                 '>= 3.0.5', '< 3.2'
  gem 'spring'
  gem 'spring-watcher-listen',  '~> 2.0.0'
  gem 'capistrano-rails',       '~> 1.1.1'
  gem 'capistrano-passenger',   '~> 0.1.1'
  gem 'capistrano-rvm',         '~> 0.1.2'
  gem 'capistrano-sidekiq',     github: 'seuros/capistrano-sidekiq'
  gem 'capistrano-foreman'
end

group :test do
  gem 'database_cleaner',       '~> 1.7'
  gem 'shoulda-matchers',       '~> 4.1', '>= 4.1.2'
end

gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
