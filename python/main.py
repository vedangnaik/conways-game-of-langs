import time
import argparse
from pathlib import Path

parser = argparse.ArgumentParser(description="Conway's Game of Life, in Python")
parser.add_argument('board_size', type=int, help="Side length of simulated board.", metavar='size')
parser.add_argument('num_timesteps', type=int, help="Number of timesteps to simulate.", metavar='N')
parser.add_argument('--input', type=argparse.FileType('r'), help="path to text file of board's initial state. default: ./start.txt", default="./start.txt", metavar='file')
parser.add_argument('--output', type=Path, help="path to a directory to write temporary files to. default: ./temp", default="./temp", metavar='dir')

class Board:
    def __init__(self, size):
        self.size = size
        self.__board = [['0'] * size for _ in range(size)]

    def get(self, row, col):
        return self.__board[row][col] == '1'

    def getRow(self, row):
        return self.__board[row]

    def set(self, row, col):
        self.__board[row][col] = '1'
    
    def unset(self, row, col):
        self.__board[row][col] = '0'

def getNumNeighbors(board, row, col):
    count = 0
    if board.get((row-1) % board.size, (col-1) % board.size): count += 1
    if board.get((row-1) % board.size, (col  ) % board.size): count += 1
    if board.get((row-1) % board.size, (col+1) % board.size): count += 1
    if board.get((row  ) % board.size, (col-1) % board.size): count += 1
    if board.get((row  ) % board.size, (col+1) % board.size): count += 1
    if board.get((row+1) % board.size, (col-1) % board.size): count += 1
    if board.get((row+1) % board.size, (col  ) % board.size): count += 1
    if board.get((row+1) % board.size, (col+1) % board.size): count += 1
    return count

def saveAsPBMP1(board, filename):
    f = open(filename, "w")
    f.write(f"P1\n{board.size} {board.size}\n")
    for row in range(board.size):
        f.write(" ".join(board.getRow(row)) + "\n")
    f.close()

def main():
    args = parser.parse_args()

    # Set up boards and time stuff
    now = Board(args.board_size)
    timestep = 0

    # Read in initial state
    for line in args.input.readlines():
        now.set(*map(int, line.strip().split()))
    args.input.close()

    # Infinitely simulate next timestep and save image.
    while timestep < args.num_timesteps:
        saveAsPBMP1(now, f"{args.output}/{timestep}.pbm")
        timestep += 1
        
        nxt = Board(args.board_size)
        for row in range(args.board_size):
            for col in range(args.board_size):
                numNeighbors = getNumNeighbors(now, row, col)
                if now.get(row, col):
                    if 2 <= numNeighbors <= 3:
                        nxt.set(row, col)
                else:
                    if numNeighbors == 3:
                        nxt.set(row, col)
        now = nxt
        
                
if __name__ == "__main__":
    main()