class RPS::Round
  attr_accessor :id, :game_id, :player1_move, :player2_move, :winner
  def initialize ( id, game_id, player1_move, player2_move, winner )
    @id = id
    @game_id = game_id
    @player1_move = player1_move
    @player2_move = player2_move
    @winner = winner # 0 tie, 1 for player1, 2 for player2
  end
end
