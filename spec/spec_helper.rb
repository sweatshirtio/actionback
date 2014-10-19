ENV['RAILS_ENV'] = 'test'

require 'bundler/setup'
Bundler.setup

require File.expand_path('../dummy/config/environment.rb',  __FILE__)

require './spec/support/helpers/controller_additions_helpers.rb'

RSpec.configure do |config|

end
