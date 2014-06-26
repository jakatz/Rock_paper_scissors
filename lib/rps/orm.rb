require 'pg'

module RPS
  class ORM
    attr_reader :db_adapter
    def initialize
      @db_adapter = PG.connect(host: 'localhost', dbname: 'rps')
      create_tables
    end

    def create_tables
      create_players_table
      create_games_table
      create_rounds_table
    end

    def drop_tables
      command = <<-SQL
        DROP TABLE players;
        DROP TABLE rounds;
        DROP TABLE games;
      SQL

      @db_adapter.exec(command)
    end

    def reset_tables
      drop_tables
      create_tables
    end

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ creating tables ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

    def create_players_table
      command = <<-SQL
        CREATE TABLE if NOT EXISTS players(
          id SERIAL PRIMARY KEY,
          username TEXT,
          password TEXT,
          win_count INTEGER,
          games_played INTEGER
        );
      SQL
      @db_adapter.exec(command)
    end

    def create_games_table
      command = <<-SQL
        CREATE TABLE if NOT EXISTS games(
          id SERIAL PRIMARY KEY,
          player1 INTEGER,
          player2 INTEGER,
          winner INTEGER
        );
      SQL
      @db_adapter.exec(command)
    end

    def create_rounds_table
      command = <<-SQL
        CREATE TABLE if NOT EXISTS rounds(
          id SERIAL PRIMARY KEY,
          game_id INTEGER REFERENCES games(id),
          player1_move TEXT,
          player2_move TEXT,
          winner INTEGER
        );
      SQL
      @db_adapter.exec(command)
    end

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ adding rows to tables ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~



    def add_player(username, password, win_count = 0, games_played = 0)
      command = <<-SQL
        INSERT INTO players(username, password, win_count, games_played)
        VALUES('#{username}', '#{password}', '#{win_count}', '#{games_played}')
        RETURNING *;
      SQL

      p = @db_adapter.exec(command).values.first
      RPS::Player.new(p[0].to_i, p[1], p[2], p[3].to_i, p[4].to_i)
    end

    def add_game(player1, player2, winner = -1)
      command = <<-SQL
        INSERT INTO games(player1, player2, winner)
        VALUES('#{player1}', '#{player2}', '#{winner}')
        RETURNING *;
      SQL

      g = @db_adapter.exec(command).values.first
      RPS::Game.new(g[0].to_i, g[1].to_i, g[2].to_i, g[3].to_i)
    end

    def initialize_round(game_id, player1_move, player2_move = nil, winner = -1)
      command = <<-SQL
        INSERT INTO rounds(game_id, player1_move, player2_move, winner)
        VALUES('#{game_id}', '#{player1_move}', '#{player2_move}', '#{winner}')
        RETURNING *;
      SQL

      r = @db_adapter.exec(command).values.first
      RPS::Round.new(r[0].to_i, r[1], r[2], r[3].to_i)
    end

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ selecting rows in tables ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

    def list_players
      command = <<-SQL
      SELECT * FROM players
      SQL
      result = @db_adapter.exec( command )
      players = []
      result.values.each do |player|
        players<<Player.new( player[0].to_i, player[1],
          player[2], player[3].to_i, player[4].to_i)
      end
      return players
    end

    def select_player( username )
      command = <<-SQL
        SELECT * FROM players
        WHERE username = '#{ username }';
      SQL
        result = @db_adapter.exec(command)
      unless result.values==[]
        result = result.values.first
        Player.new( result[0].to_i, result[1],
          result[2], result[3].to_i, result[4].to_i)
      else
        nil
      end
    end

    def select_player_by_id( id )
      command = <<-SQL
        SELECT * FROM players
        WHERE id = '#{ id }';
      SQL
        result = @db_adapter.exec(command)
      unless result.values==[]
        result = result.values.first
        Player.new( result[0].to_i, result[1],
          result[2], result[3].to_i, result[4].to_i)
      else
        nil
      end
    end

    def select_game( gid )
      command = <<-SQL
        SELECT * FROM games
        WHERE id = '#{ gid }';
      SQL
      result = @db_adapter.exec(command)[0]
      Game.new( result['id'].to_i, result['player1'].to_i,
        result['player2'].to_i, result['winner'].to_i)
    end


    def select_round( rid )
      command = <<-SQL
      SELECT * FROM rounds
      WHERE id = '#{ rid }';
      SQL
      result = @db_adapter.exec( command )[0]
      RPS::Round.new( result['id'].to_i, result['player1_move'],
        result['player2_move'], result['winner'].to_i)
    end

    def list_games_by_player( player_id )
      command = <<-SQL
        SELECT * FROM games
        WHERE player1 = '#{player_id}' OR player2 = '#{player_id}'
      SQL

      result = @db_adapter.exec(command)
      result.map do |game|
        RPS::Game.new( game['id'].to_i, game['player1'].to_i,
        game['player2'].to_i, game['winner'].to_i )
      end
    end

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ updating rows in tables ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

    def mark_winner(game, player_id)
      command = <<-SQL
        UPDATE games SET winner = '#{ player_id }'
        WHERE id = '#{game.id}';
        UPDATE players SET win_count = win_count+1
        WHERE id = '#{ player_id }';
      SQL

      result = @db_adapter.exec(command)
    end

    # do we ever use this method??

    # def mark_round( player1_id, player2_id )
    #   command  = <<-SQL
    #   UPDATE players SET games_played = games_played+1
    #   WHERE id = '#{ player1_id }' OR id = '#{ player2_id }'
    #   SQL

    #   result = @db_adapter.exec(command)
    # end

    def add_move(round_id, player_id, player_move)
      command = <<-SQL
      UPDATE rounds SET player2_move = '#{ player_move }'
      WHERE id = '#{round_id}'
      SQL

      result = @db_adapter.exec(command)
      set_winner(round_id)
    end

    def set_winner(rid)
      # find moves
      command = <<-SQL
        SELECT player1_move, player2_move FROM rounds
        WHERE id = '#{rid}'
      SQL
      result = @db_adapter.exec(command).values.first
      winner = play(result[0], result[1])

      # update winner
      command = <<-SQL
        UPDATE rounds SET winner = '#{winner}'
        WHERE id = '#{rid}'
      SQL
      @db_adapter.exec(command)
    end
  end

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ setting singleton ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


  def self.orm
    @__orm_instance ||= ORM.new
  end
end
