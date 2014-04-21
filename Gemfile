source 'https://rubygems.org'

gem 'rails', '~> 3.2'
gem "jquery-rails", "~> 2.2"

gem 'haml-rails', '~> 0.4'

#Search
gem 'sunspot_mongoid2'
gem 'sunspot_solr'
gem 'sunspot_cell', :git => 'git://github.com/zheileman/sunspot_cell.git'
gem 'sunspot_cell_jars'
gem 'progress_bar'

#Representers
# gem 'roar', '~> 0.11.19'
gem 'roar-rails', "0.1.0"
gem 'billit_representers', '0.9.3'
gem 'will_paginate', '~> 3.0'

#Dates
gem 'business_time'

# Clean ruby syntax for writing and deploying cron jobs (for rvm)
gem 'whenever', :git => 'https://github.com/Insomniware/whenever.git', :require => false
#gem 'whenever', :require => false #for non rvm

group :development, :test do
  gem 'rspec-rails'
  gem 'factory_girl_rails'
  gem 'guard-bundler'
  gem 'guard-rails'
  gem 'guard-rspec'
  gem 'awesome_print'
  gem 'newrelic_rpm'
end

group :test do
  gem 'database_cleaner'
  gem 'faker'
  gem 'webmock'
end
