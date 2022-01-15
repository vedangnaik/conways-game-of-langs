import argparse
import re

class Board:
    def __init__(self, size):
        if not (0 < size):
            raise ValueError("Please provide a positive integer board size.")
        self.size = size
        self._board = [[False] * size for _ in range(size)]

    def is_set(self, row, col):
        if not (0 <= row < self.size and 0 <= col < self.size):
            raise IndexError(f"index {row} or {col} is out of bounds for array with size {self.size}.")
        return self._board[row][col]

    def set(self, row, col):
        if not (0 <= row < self.size and 0 <= col < self.size):
            raise IndexError(f"index {row} or {col} is out of bounds for array with size {self.size}.")
        self._board[row][col] = True

def save_as_PBMP1(board, filename):
    with open(filename, "w") as f:
        f.write(f"P1\n{board.size} {board.size}\n")
        for row in range(board.size):
            f.write(" ".join(['1' if board.is_set(row, col) else '0' for col in range(board.size)]) + "\n")

def get_num_neighbors(board, row, col):
    count = 0
    if board.is_set((row-1) % board.size, (col-1) % board.size): count += 1
    if board.is_set((row-1) % board.size, (col  ) % board.size): count += 1
    if board.is_set((row-1) % board.size, (col+1) % board.size): count += 1
    if board.is_set((row  ) % board.size, (col-1) % board.size): count += 1
    if board.is_set((row  ) % board.size, (col+1) % board.size): count += 1
    if board.is_set((row+1) % board.size, (col-1) % board.size): count += 1
    if board.is_set((row+1) % board.size, (col  ) % board.size): count += 1
    if board.is_set((row+1) % board.size, (col+1) % board.size): count += 1
    return count

def main():
    parser = argparse.ArgumentParser(description="Conway's Game of Life, in Python")
    parser.add_argument('board_size', type=int, help="side length of simulated board", metavar='size')
    parser.add_argument('num_timesteps', type=int, help="number of timesteps to simulate", metavar='N')
    parser.add_argument('input', type=argparse.FileType('r'), help="path to text file of board's initial state", metavar='file')
    args = parser.parse_args()

    # Set up boards and time stuff
    now = Board(args.board_size)
    timestep = 0

    # Read in initial state
    fileStr = args.input.read()
    if re.compile("^(\d+\s\d+(\r\n|\r|\n))+$").match(fileStr) is None:
        raise AssertionError(f"Initial state file {args.input.name} must satisfy regular expression ^(\d+\s\d+(\\r\\n|\\r|\\n))+$.")
    for coord in fileStr.strip().splitlines():
        now.set(*map(int, coord.strip().split()))
    args.input.close()

    # Simulate next timestep and save image until simulation is done.
    while timestep < args.num_timesteps:
        save_as_PBMP1(now, f"{timestep}.pbm")
        timestep += 1

        _next = Board(args.board_size)
        for row in range(args.board_size):
            for col in range(args.board_size):
                numNeighbors = get_num_neighbors(now, row, col)
                if now.is_set(row, col):
                    if 2 <= numNeighbors <= 3:
                        _next.set(row, col)
                else:
                    if numNeighbors == 3:
                        _next.set(row, col)
        now = _next

if __name__ == "__main__":
    main()