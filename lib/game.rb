class Game
  MOVE_CHEER_UPS = ['Smart move!           .',
                    'I am impressed        .']
  WRONG_MOVES =    ['Impossible move       .',
                    'Cannot move that piece.']
  GREETING =        'Make a move           .'
  VICTORY = 'You won, hooray!'
  VICTORY_POSITIONS = [
    [
      1, 2, 3, 4,
      5, 6, 7, 8,
      9, 10,11,12,
      13,14,15,0
    ],
    [
      13,9, 5, 1,
      14,10,6, 2,
      15,11,7, 3,
      0, 12,8, 4
    ]
  ]

  def initialize(position)
    @cheerups = MOVE_CHEER_UPS.cycle
    @wrong_moves = WRONG_MOVES.cycle
    @position = position
    @ended = false
  end

  def start
    [GREETING, @position]
  end

  def move(button)
    button_idx = @position.index(button)
    zero_idx = @position.index(0)
    msg = if neighbors?(button_idx, zero_idx)
            swap(button_idx, zero_idx)
            check_victory
            @cheerups.next
          else
            @wrong_moves.next
          end
    return [VICTORY, nil] if ended?
    [msg, @position]
  end

  def ended?
    @ended
  end

  private
  def neighbors?(a, b)
    ax, ay = coords(a)
    bx, by = coords(b)
    (ax - bx).abs + (ay - by).abs == 1
  end

  def coords(point)
    [point % 4, point / 4]
  end

  def swap(a, b)
    @position[a], @position[b] = @position[b], @position[a]
  end

  def check_victory
    @ended = true if VICTORY_POSITIONS.include?(@position)
  end
end
