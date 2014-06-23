def play(p1_move, p2_move)
  case [p1_move, p2_move]
    when ['r', 's'], ['s', 'p'], ['p', 'r']
      player1
    when ['s', 'r'], ['p', 's'], ['r', 'p']
      player2
  end
end
