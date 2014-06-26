module RPS
  class Create_player < TransactionScript
    def run( inputs )
      player = RPS.orm.select_player( inputs[:username] )
      return failure( :username_already_chosen ) unless player.nil?
      player = RPS.orm.add_player(inputs[:username], inputs[:password])
      success player: player
    end
  end
end
