require 'pg'

module RPS
  class ORM
    attr_reader :db_adapter
    def initialize
      @db_adapter = PG.connect(host: 'localhost', dbname: 'rps')
    end

    def create_tables
      create_players_table
    end

    def drop_tables
      command = <<-SQL
        DROP TABLE players;
      SQL

      @db_adapter.exec(command)
    end

    def reset_tables
      drop_tables
      create_tables
    end

    def create_players_table
      command = <<-SQL
        CREATE TABLE if NOT EXISTS players(
          id SERIAL PRIMARY KEY,
          name text,
          win_count integer,
          games_player integer
        );
      SQL
      @db_adapter.exec(command)
    end

    def add_player(name, win_count=-1, games_player=-1)
      command = <<-SQL
        INSERT INTO players(name, win_count, games_player)
        VALUES('#{name}', '#{win_count}', '#{games_player}')
        RETURNING *;
      SQL

      # ["1", "Gideon", "-1", "-1"]
      p = @db_adapter.exec(command).values.first
      RPS::Player.new(p[0], p[1] , p[2] , p[3])
    end
  end

  def self.orm
    @__orm_instance ||= ORM.new
  end
end
