module RPS
  class Create_player < TransactionScript
    def run( inputs )
      round = RPS.orm.select_round( inputs[:game_id] )
      return failure( :name_already_chosen ) unless player.nil?

      success :player => player
    end
  end
end
