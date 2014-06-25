class RPS::Player
  attr_reader :id, :username, :password, :win_count, :games_played

  def initialize(id, username, password, win_count, games_played)
    @id = id
    @username = username
    @password = password
    @win_count = win_count
    @games_played = games_played
  end

  def win_game
    @win_count += 1
  end

  def lose_game
    @games_played += 1
  end
end
