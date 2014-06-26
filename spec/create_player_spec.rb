require_relative 'spec_helper.rb'
require 'pg'



describe 'Create_player' do

  before(:all) do
    RPS.orm.instance_variable_set(:@db_adapter, PG.connect(host: 'localhost', dbname: 'rps-test') )
    RPS.orm.db_adapter.set_error_verbosity(PG::PQERRORS_TERSE)
    RPS.orm.create_tables
  end

  before(:each) do
    RPS.orm.drop_tables
    RPS.orm.create_tables
  end

  after(:all) do
    RPS.orm.drop_tables
  end
  describe '#run' do

    it 'returns an error if the user exists' do
      RPS.orm.add_player('Gideon', '1234')

      result = RPS::Create_player.run(username:'Gideon', password: '1255')
      expect(result.success?).to eq(false)
    end
    it 'returns a player if no error exists' do
      result = RPS::Create_player.run(username:'jon', password: '1255')

      expect( result.success? ).to eq(true)

      expect( result.player.username ).to eq( 'jon' )
    end
  end
end
