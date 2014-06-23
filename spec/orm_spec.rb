require_relative 'spec_helper.rb'

require 'pg'

describe 'ORM' do
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

  it "is an ORM" do
    expect(RPS.orm).to be_a(RPS::ORM)
  end

  it "is created with a db adapter" do
    expect(RPS.orm.db_adapter.db).to eq("rps-test")
  end

  describe 'players table' do
    describe '#add_player' do
      it 'adds the player to the database and returns the Player instance' do
        result = RPS.orm.add_player('Gideon')
        expect(result).to be_a(RPS::Player)
      end
    end
  end
end
