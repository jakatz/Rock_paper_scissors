def play(p1_move, p2_move)
  case [p1_move, p2_move]
    when ['r', 's'], ['s', 'p'], ['p', 'r']
      1
    when ['s', 'r'], ['p', 's'], ['r', 'p']
      2
    else
      0
  end
end
