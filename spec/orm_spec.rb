require_relative 'spec_helper.rb'

require 'pg'

describe 'ORM' do
  before(:all) do
    RPS.orm.instance_variable_set(:@db_adapter, PG.connect(host: 'localhost', dbname: 'rps-test') )
    RPS.orm.db_adapter.set_error_verbosity(PG::PQERRORS_TERSE)
    RPS.orm.create_tables
  end

  before(:all) do
    RPS.orm.create_tables
  end

  after(:each) do
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
        result = RPS.orm.add_player('Gideon', '1234')
        expect(result).to be_a(RPS::Player)
      end
    end
  end

  describe 'games table' do
    describe '#add_game' do
      it 'adds the game to the database and returns the Game instance' do
        p1 = RPS.orm.add_player('Gideon', '1234')
        p2 = RPS.orm.add_player('Jon', '321')
        game = RPS.orm.add_game(p1.id, p2.id)
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
          p1 = RPS.orm.add_player('Gideon', '1234')
          p2 = RPS.orm.add_player('Jon', '321')
          game = RPS.orm.add_game(p1.id, p2.id, -1)
          RPS.orm.mark_winner(game.id, p1.id)
          game = RPS.orm.select_game( game.id )
          p1 = RPS.orm.select_player( p1.username )
          expect(game.winner).to eq(p1.id)
        end

        it "increases the player's win count by 1" do
          p1 = RPS.orm.add_player('Gideon', '1234')
          p2 = RPS.orm.add_player('Jon', '321')
          game = RPS.orm.add_game(p1.id, p2.id)
          RPS.orm.mark_winner(game.id, p1.id)
          RPS.orm.mark_round( p1.id, p2.id )
          p1 = RPS.orm.select_player( p1.username )
          game = RPS.orm.select_game( game.id )
          expect(p1.win_count).to eq(1)
          expect(p1.games_played).to eq(1)
          expect(p2.win_count).to eq(0)
        end
      end
    end

    describe '#list_games_by_player' do
      it "returns an array of all games for that player" do
        p1 = RPS.orm.add_player('Gideon', '1234')
        p2 = RPS.orm.add_player('Jon', '321')
        p3 = RPS.orm.add_player('Jered', '321')
        g1 = RPS.orm.add_game(p1.id, p2.id)
        list1 = RPS.orm.list_games_by_player(p1.id)
        expect(list1.size).to eq(1)
        expect(list1.first.id).to eq(g1.id)

        g2 = RPS.orm.add_game(p1.id, p3.id)
        list2 = RPS.orm.list_games_by_player(p1.id)
        expect(list2.size).to eq(2)
        expect(list2.last.id).to eq(g2.id)
      end
    end

    describe '#list_players' do
      it "returns an array of all games for that player" do
        p1 = RPS.orm.add_player('Gideon', '1234')
        p2 = RPS.orm.add_player('Jon', '321')
        p3 = RPS.orm.add_player('Jered', '321')
        list1 = RPS.orm.list_players
        expect(list1.size).to eq(3)

        p4 = RPS.orm.add_player('tom', '321')
        list2 = RPS.orm.list_players
        expect(list2.size).to eq(4)
      end
    end

    describe "#count_rounds" do
      context "the game is not over" do
        it "" do
          p1 = RPS.orm.add_player('Gideon', 'gewulf', '1234')
          p2 = RPS.orm.add_player('Jon', 'meowmix', '321')
          game = RPS.orm.add_game(p1.id, p2.id, -1)
        end
      end

      context "the game is over" do
        it "" do
          p1 = RPS.orm.add_player('Gideon', 'gewulf', '1234')
          p2 = RPS.orm.add_player('Jon', 'meowmix', '321')
          game = RPS.orm.add_game(p1.id, p2.id, -1)
        end
      end
    end
  end

  describe 'rounds table' do
    describe '#initialize_round' do
      it 'adds the round to the database and returns the Round instance' do
        p1 = RPS.orm.add_player('Gideon', '1234')
        p2 = RPS.orm.add_player('Jon', '321')
        g = RPS.orm.add_game(p1.id, p2.id)
        round = RPS.orm.initialize_round(g.id, 'r')

        expect(round).to be_a(RPS::Round)
        expect(round.id).to be_a(Fixnum)
        round = RPS.orm.select_round( round.id )
        expect(round.player1_move).to eq('r')
        expect(round.player2_move).to eq("")
        expect(round.winner).to eq(-1)
      end
    end

    describe '#add_move' do
      context 'the round has not been initialized' do
        it 'returns nil' do
        end
      end

      context 'the round has been initialized' do
        it 'adds the second move to the round' do
          p1 = RPS.orm.add_player('Gideon', '1234')
          p2 = RPS.orm.add_player('Jon', '321')
          g = RPS.orm.add_game(p1.id, p2.id)
          round = RPS.orm.initialize_round(g.id, 'r')

          RPS.orm.add_move(round.id, p2.id, 's')
          round= RPS.orm.select_round( round.id )
          expect(round.player2_move).to eq('s')
        end
      end
    end
    describe '#set_winner' do
      it 'sets the winner after player2 moves' do
        p1 = RPS.orm.add_player('Gideon', '1234')
        p2 = RPS.orm.add_player('Jon', '321')
        g = RPS.orm.add_game(p1.id, p2.id)
        round = RPS.orm.initialize_round(g.id, 'r')
        RPS.orm.add_move(round.id, p2.id, 's')

        expect(RPS.orm.select_round(round.id).winner).to eq(1)
      end
    end

    describe '#check_if_gameover' do
      # changes winner of game, wins by player, and winner of round
      it 'says player1 wins' do
        RPS.orm.add_player('test', 'tester')
        RPS.orm.add_player('test1', 'tester1')
        p1 = RPS.orm.add_player('Gideon', '1234')
        p2 = RPS.orm.add_player('Jon', '321')
        g = RPS.orm.add_game(p1.id, p2.id)
        round = RPS.orm.initialize_round(g.id, 'r')
        RPS.orm.add_move(round.id, p2.id, 's')
        round = RPS.orm.initialize_round(g.id, 'r')
        RPS.orm.add_move(round.id, p2.id, 's')
        round = RPS.orm.initialize_round(g.id, 'r')
        RPS.orm.add_move(round.id, p2.id, 's')

        RPS.orm.check_if_gameover(g.id) # method start chain of events
        expect(RPS.orm.select_game(g.id).winner).to eq(p1.id)
        expect(RPS.orm.select_round(round.id).winner).to eq(1) # 1 for player2
        expect(RPS.orm.select_player_by_id(p1.id).win_count).to eq(p1.win_count+1)
        expect(RPS.orm.select_player_by_id(p2.id).win_count).to eq(p2.win_count)
      end
      it 'says player2 wins' do
        RPS.orm.add_player('test', 'tester')
        RPS.orm.add_player('test1', 'tester1')
        p1 = RPS.orm.add_player('Gideon', '1234')
        p2 = RPS.orm.add_player('Jon', '321')
        g = RPS.orm.add_game(p1.id, p2.id)
        round = RPS.orm.initialize_round(g.id, 's')
        RPS.orm.add_move(round.id, p2.id, 'r')
        round = RPS.orm.initialize_round(g.id, 's')
        RPS.orm.add_move(round.id, p2.id, 'r')
        round = RPS.orm.initialize_round(g.id, 's')
        RPS.orm.add_move(round.id, p2.id, 'r')

        RPS.orm.check_if_gameover(g.id) # method start chain of events
        expect(RPS.orm.select_game(g.id).winner).to eq(p2.id)
        expect(RPS.orm.select_round(round.id).winner).to eq(2) # 1 for player2
        expect(RPS.orm.select_player_by_id(p2.id).win_count).to eq(p2.win_count+1)
        expect(RPS.orm.select_player_by_id(p1.id).win_count).to eq(p1.win_count)
      end
    end
  end
end
