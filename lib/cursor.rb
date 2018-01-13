class Cursor
  # - Move the cursor up N lines:
  #   \033[<N>A
  def self.up(n=1)
    p '\033[<' + n.to_s + '>A'
  end
  # - Move the cursor down N lines:
  #   \033[<N>B
  def self.down(n=1)
    p '\033[<'+ n.to_s + '>B'
  end
#   - Position the Cursor:
#   \033[<L>;<C>H
#      Or
#   \033[<L>;<C>f
#   puts the cursor at line L and column C.
# - Move the cursor forward N columns:
#   \033[<N>C
# - Move the cursor backward N columns:
#   \033[<N>D
#
# - Clear the screen, move to (0,0):
#   \033[2J
# - Erase to end of line:
#   \033[K
#
# - Save cursor position:
#   \033[s
# - Restore cursor position:
#   \033[u
end
