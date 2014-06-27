def play(p1_move, p2_move)
  case [p1_move, p2_move]
    when ['r', 's'], ['s', 'p'], ['p', 'r']
      1 # player1
    when ['s', 'r'], ['p', 's'], ['r', 'p']
      2 # player1
    else
      0 # tie
  end
end
