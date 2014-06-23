class RPS::Player
  attr_reader :id, :name, :win_count, :games_played

  def initialize(id, name, win_count, games_played)
    @id = id
    @name = name
    @win_count = win_count
    @games_played = games_played
  end
end
