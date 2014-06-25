module RPS
  class player_turn < TransactionScript
    def run( inputs )
      round = RPS.orm.select_player( inputs[:player_id] )

      return failure( :name_already_chosen ) unless player.nil?

      success :player => player
    end
  end
end
