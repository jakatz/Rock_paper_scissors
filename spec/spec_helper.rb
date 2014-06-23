require './lib/rps-manager.rb'
require 'spec_helper'
require 'rspec'
require 'pry-byebug'

RSpec.configure do |config|
  config.before(:each) do
    RPS.instance_variable_set(:@db_adapter, nil)
  end
end

