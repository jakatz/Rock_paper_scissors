
module RPS
  class Sign_in < TransactionScript
    def run( inputs )
      player = RPS.orm.select_player( inputs[:password] )
      return failure( :player_does_not_exist ) if player.nil?
      return failure( :password_incorrect ) unless authenticate( player, password )
      success player: player
  end

  def authenticate( player, password )
    password == player.password
  end
end
