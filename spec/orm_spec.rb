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
        result = RPS.orm.add_player('Gideon', 'gewulf', '1234')
        expect(result).to be_a(RPS::Player)
      end
    end
  end

  describe 'games table' do
    describe '#add_game' do
      it 'adds the game to the database and returns the Game instance' do
        p1 = RPS.orm.add_player('Gideon', 'gewulf', '1234')
        p2 = RPS.orm.add_player('Jon', 'meowmix', '321')
        game = RPS.orm.add_game(p1.id, p2.id, -1)
        expect(game).to be_a(RPS::Game)
        expect(game.id).to be_a(Fixnum)
        expect(game.player1).to eq(p1.id)
        expect(game.player2).to eq(p2.id)
        expect(game.winner).to eq(-1)
      end
    end

    describe '#mark_winner' do
      context "the game does not yet have a winner" do
        it 'changes the game winner to the id of the winning player and returns nil' do
          p1 = RPS.orm.add_player('Gideon', 'gewulf', '1234')
          p2 = RPS.orm.add_player('Jon', 'meowmix', '321')
          game = RPS.orm.add_game(p1.id, p2.id, -1)
          RPS.orm.mark_winner(game, p1.id)
          game = RPS.orm.select_game( game.id )
          p1 = RPS.orm.select_player( p1.id )
          game =
          expect(game.winner).to eq(p1.id)
        end

        it "increases the player's win count by 1" do
          p1 = RPS.orm.add_player('Gideon', 'gewulf', '1234')
          p2 = RPS.orm.add_player('Jon', 'meowmix', '321')
          game = RPS.orm.add_game(p1.id, p2.id, -1)
          RPS.orm.mark_winner(game, p1.id)
          RPS.orm.mark_round( p1.id, p2.id )
          p1 = RPS.orm.select_player( p1.id )
          game = RPS.orm.select_game( game.id )
          expect(p1.win_count).to eq(1)
          expect(p1.games_played).to eq(1)
          expect(p2.win_count).to eq(0)
        end
      end
    end
  end

  describe 'rounds table' do
    describe '#add_round' do
      it 'adds the round to the database and returns the Round instance' do
        p1 = RPS.orm.add_player('Gideon', 'gewulf', '1234')
        p2 = RPS.orm.add_player('Jon', 'meowmix', '321')
        round = RPS.orm.add_round('r', 'p')

        expect(round).to be_a(RPS::Round)
        expect(round.id).to be_a(Fixnum)
        round = RPS.orm.select_round( round.id )
        expect(round.player1_move).to eq('r')
        expect(round.player2_move).to eq('p')
        expect(round.winner).to eq(2)
      end
    end
  end
end
