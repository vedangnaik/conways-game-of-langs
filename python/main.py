import time

class Board:
    def __init__(self, size):
        self.size = size
        self.__board = [['0'] * size for _ in range(size)]

    def get(self, row, col):
        return self.__board[row][col] == '1'

    def set(self, row, col):
        self.__board[row][col] = '1'
    
    def unset(self, row, col):
        self.__board[row][col] = '0'
    
    def __str__(self):
        s = ""
        for row in range(self.size):
            s = s + " ".join(self.__board[row]) + "\n"
        return s

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

def main():
    # Set up boards and time stuff
    size = 3
    now = Board(size)
    timestep = 0

    # Read in initial state
    # TODO

    # Infinitely simulate next timestep and save image.
    while True:
        nxt = Board(size)
        for row in range(size):
            for col in range(size):
                numNeighbors = getNumNeighbors(now, row, col)
                if now.get(row, col) and (numNeighbors < 2 or numNeighbors > 3):
                    nxt.unset(row, col)
                else:
                    if numNeighbors == 3:
                        nxt.set(row, col)
        now = nxt
        print(now)
        time.sleep(1)
                
if __name__ == "__main__":
    main()