class RPS::Round
  attr_accessor :id, :player1, :player2, :winner
  def initialize ( id, player1, player2, winner = nil )
    @id = id
    @player1 = player1
    @player2 = player2
    @winner = winner
  end



end
