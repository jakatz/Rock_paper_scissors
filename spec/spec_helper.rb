require './lib/rps-manager.rb'

RSpec.configure do |config|
  config.before(:each) do
    RPS.instance_variable_set(:@db_adapter, nil)
  end
end
