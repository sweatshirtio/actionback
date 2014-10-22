source "https://rubygems.org"
gemspec

version = ENV['RAILS_VERSION'] || '4.0'

rails_version = ENV['RAILS_VERSION'] || 'default'

rails = case rails_version

when 'master'
  { github: 'rails/rails' }
when 'default'
  '>= 3.2.0'
else
  "~> #{rails_version}"
end

gem 'rails', rails
