module RPS
  class Create_game < TransactionScript
    def run( inputs )
      player1 = RPS.orm.select_player( inputs[:player1_name] )
      player2 = RPS.orm.select_player( inputs[:player2_name] )

      return failure( :player_not_found ) if player1.nil? || player2.nil?

      game = RPS.orm.add_game( player1, player2 )

      success player1: player1, player2: player2, game: game
    end
  end
end
