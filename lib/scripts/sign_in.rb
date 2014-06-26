
module RPS

  class Sign_in < TransactionScript
    def run( inputs )
      player = RPS.orm.select_player( inputs[:username] )
      return failure( :player_does_not_exist ) if player.nil?
      unless authenticate( player, inputs[:password] )
        return failure( :password_incorrect )
      end
      success player: player
    end

    def authenticate( player, password )
      password == player.password
    end
  end

end
