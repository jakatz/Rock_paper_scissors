class RPS::Game
  attr_reader :id, :player1, :player2
  attr_accessor :winner

  def initialize(id, player1, player2, winner = -1)
    @id = id
    @player1 = player1
    @player2 = player2
    @winner = winner
  end

  def mark_winner(pid)
  end
end
