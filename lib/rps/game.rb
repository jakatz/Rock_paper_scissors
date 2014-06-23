class RPS::Game
  attr_accessor :id, :player1, :player2, :winner

  def initialize(id, player1, player2, winner)
    @id = id
    @player1 = player1
    @player2 = player2
    @winner = winner
  end

  def mark_winner(pid)
  end
end
