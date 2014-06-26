require_relative 'spec_helper.rb'

require 'pg'



describe 'Player Class' do

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

  let(:player) {RPS::Player.new(1, 'Gideon', '1234', 5, 9)} #id, name, wins, games_played
  describe '#initialize' do
    it 'initializes values in player class' do
      expect(player.id).to eq(1)
      expect(player.username).to eq('Gideon')
      expect(player.win_count).to eq(5)
      expect(player.games_played).to eq(9)
    end
    it 'creates instance of player class' do
      expect(player).to be_a(RPS::Player)
    end
  end
end
