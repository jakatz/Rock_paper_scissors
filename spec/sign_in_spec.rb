require_relative 'spec_helper.rb'



describe 'Sign_in' do

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

    it 'returns an error message if password is wrong' do
      result = RPS::Sign_in.run( password: '1222', name: 'Gideon' )
      expect( result.success? ).to eq(false)
    end

    it 'returns an error message if username does not exist' do
      result = RPS::Sign_in.run( password: '1234', name: 'jon' )
      expect( result.success? ).to eq(false)
    end

    it 'returns an player if there is no error' do
      player = RPS.orm.add_player( 'Gideon', '1234'  )
      result = RPS::Sign_in.run({password: '1234', username: 'Gideon'})
      expect( result.success? ).to eq(true)
      expect( result.player.username ).to eq( 'Gideon' )
    end
  end
end
