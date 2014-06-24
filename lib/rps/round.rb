class RPS::Round
  attr_accessor :id, :player1_move, :player2_move, :winner
  def initialize ( id, player1_move, player2_move, winner )
    @id = id
    @player1_move = player1_move
    @player2_move = player2_move
    @winner = winner # 0 tie, 1 for player1, 2 for player2
  end
end
