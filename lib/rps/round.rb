class RPS::Round
  attr_accessor :id, :player1_move, :player2_move, :round_winner
  def initialize ( id, player1_move, player2_move, round_winner )
    @id = id
    @player1_move = player1_move
    @player2_move = player2_move
    @round_winner = round_winner
  end
end
