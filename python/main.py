import argparse

parser = argparse.ArgumentParser(description="Conway's Game of Life, in Python")
parser.add_argument('board_size', type=int, help="Side length of simulated board.", metavar='size')
parser.add_argument('num_timesteps', type=int, help="Number of timesteps to simulate.", metavar='N')
parser.add_argument('--input', type=argparse.FileType('r'), help="path to text file of board's initial state. default: ./start.txt", default="./start.txt", metavar='file')

class Board:
    def __init__(self, size):
        if not (0 < size):
            raise ValueError("Please provide a positive integer board size.")
        self.size = size
        self.__board = [['0'] * size for _ in range(size)]

    def get(self, row, col):
        if not (0 <= row < self.size and 0 <= col < self.size):
            raise IndexError(f"index {row} or {col} is out of bounds for array with size {self.size}.")
        return self.__board[row][col] == '1'

    def getRow(self, row):
        if not (0 <= row < self.size):
            raise IndexError(f"index {row} is out of bounds for array with size {self.size}.")
        return self.__board[row]

    def set(self, row, col):
        if not (0 <= row < self.size and 0 <= col < self.size):
            raise IndexError(f"index {row} or {col} is out of bounds for array with size {self.size}.")
        self.__board[row][col] = '1'

def getNumNeighbors(board, row, col):
    if not (0 <= row < board.size and 0 <= col < board.size):
        raise IndexError(f"index {row} or {col} is out of bounds for array with size {board.size}.")
    count = 0
    if board.get((row-1) % board.size, (col-1) % board.size) == '1': count += 1
    if board.get((row-1) % board.size, (col  ) % board.size) == '1': count += 1
    if board.get((row-1) % board.size, (col+1) % board.size) == '1': count += 1
    if board.get((row  ) % board.size, (col-1) % board.size) == '1': count += 1
    if board.get((row  ) % board.size, (col+1) % board.size) == '1': count += 1
    if board.get((row+1) % board.size, (col-1) % board.size) == '1': count += 1
    if board.get((row+1) % board.size, (col  ) % board.size) == '1': count += 1
    if board.get((row+1) % board.size, (col+1) % board.size) == '1': count += 1
    return count

def saveAsPBMP1(board, filename):
    with open(filename, "w") as f:
        f.write(f"P1\n{board.size} {board.size}\n")
        for row in range(board.size):
            f.write(" ".join(board.getRow(row)) + "\n")

def main():
    args = parser.parse_args()

    # Set up boards and time stuff
    now = Board(args.board_size)
    timestep = 0

    # Read in initial state
    for line in args.input.readlines():
        now.set(*map(int, line.strip().split()))
    args.input.close()

    # Simulate next timestep and save image until simulation is done.
    while timestep < args.num_timesteps:
        saveAsPBMP1(now, f"{timestep}.pbm")
        timestep += 1

        _next = Board(args.board_size)
        for row in range(args.board_size):
            for col in range(args.board_size):
                numNeighbors = getNumNeighbors(now, row, col)
                if now.get(row, col) == '1':
                    if 2 <= numNeighbors <= 3:
                        _next.set(row, col)
                else:
                    if numNeighbors == 3:
                        _next.set(row, col)
        now = _next

if __name__ == "__main__":
    main()