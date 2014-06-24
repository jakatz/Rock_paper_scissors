require 'pg'

module RPS
  class ORM
    attr_reader :db_adapter
    def initialize
      @db_adapter = PG.connect(host: 'localhost', dbname: 'rps')
    end

    def create_tables
      create_players_table
      create_games_table
      create_rounds_table
    end

    def drop_tables
      command = <<-SQL
        DROP TABLE players;
        DROP TABLE games;
        DROP TABLE rounds;
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
          name TEXT,
          win_count INTEGER,
          games_player INTEGER
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
          player1_move TEXT,
          player2_move TEXT,
          winner integer
        );
      SQL
      @db_adapter.exec(command)
    end

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ adding rows to tables ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

    def add_player(name, win_count = -1, games_player = -1)
      command = <<-SQL
        INSERT INTO players(name, win_count, games_player)
        VALUES('#{name}', '#{win_count}', '#{games_player}')
        RETURNING *;
      SQL

      # ["1", "Gideon", "-1", "-1"]
      p = @db_adapter.exec(command).values.first
      RPS::Player.new(p[0].to_i, p[1], p[2].to_i, p[3].to_i)
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

    def add_round(player1_move, player2_move, winner = play(player1_move, player2_move))
      command = <<-SQL
        INSERT INTO rounds(player1_move, player2_move, winner)
        VALUES('#{player1_move}', '#{player2_move}', '#{winner}')
        RETURNING *;
      SQL

      r = @db_adapter.exec(command).values.first
      RPS::Round.new(r[0].to_i, r[1], r[2], r[3].to_i)
    end
  end

  def self.orm
    @__orm_instance ||= ORM.new
  end
end
