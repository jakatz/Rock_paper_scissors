module RPS
  class Create_player < TransactionScript
    def run( inputs )
      player = RPS.orm.select_player( inputs[:username] )
      return failure( :username_already_chosen ) unless player.nil?

      success :player => player
    end
  end
end
