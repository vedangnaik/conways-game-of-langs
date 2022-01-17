const fs = require('fs');
const { ArgumentParser, FileType } = require('argparse')

class Board {
    #board;
    size;

    constructor(size) {
        this.size = size;
        this.#board = []
        this.#board = new Array(this.size).fill(undefined)
            .map(_ => new Array(this.size).fill(false));
    }

    set(row, col) {
        if (row < 0 || row >= this.size || col < 0 || col >= this.size) {
            throw new RangeError(`${row} or ${col} are out of range for board with size ${this.size}`);
        }
        this.#board[row][col] = true;
    }

    isSet(row, col) {
        if (row < 0 || row >= this.size || col < 0 || col >= this.size) {
            throw new RangeError(`${row} or ${col} are out of range for board with size ${this.size}`);
        }
        return this.#board[row][col];
    }
}

function mod(n, m) {
    return ((n % m) + m) % m;
}

function saveBoardAsPBMP1(board, filename) {
    let filestring = `P1\n${board.size} ${board.size}\n`;
    s = new Array(board.size).fill("")
        .map((_, row) => {
            return new Array(board.size).fill("")
                .map((_, col) => board.isSet(row, col) ? "1" : "0")
                .join(" ");
        })
        .join("\n")
    fs.writeFileSync(filename, filestring + s);
}

function getNumNeighbors(board, row, col) {
    let count = 0;
    if (board.isSet(mod(row - 1, board.size), mod(col - 1, board.size))) { count += 1 }
    if (board.isSet(mod(row - 1, board.size), mod(col    , board.size))) { count += 1 }
    if (board.isSet(mod(row - 1, board.size), mod(col + 1, board.size))) { count += 1 }
    if (board.isSet(mod(row    , board.size), mod(col - 1, board.size))) { count += 1 }
    if (board.isSet(mod(row    , board.size), mod(col + 1, board.size))) { count += 1 }
    if (board.isSet(mod(row + 1, board.size), mod(col - 1, board.size))) { count += 1 }
    if (board.isSet(mod(row + 1, board.size), mod(col    , board.size))) { count += 1 }
    if (board.isSet(mod(row + 1, board.size), mod(col + 1, board.size))) { count += 1 }
    return count;
}

(function main() {
    const parser = new ArgumentParser({
        description: "Conway's Game of Life, in NodeJS",
        add_help: true
    });
    parser.add_argument('boardSize', { type: "int", help: "Side length of simulated board." })
    parser.add_argument('numTimesteps', { type: "int", help: "Number of timesteps to simulate." })
    parser.add_argument('initialStateFile', { type: FileType('r'), help: "Path to text file of board's initial state." })
    const args = parser.parse_args();

    // Set up board
    let board = new Board(args.boardSize);

    // Read in initial state
    const fileString = fs.readFileSync(args.initialStateFile.fd, { encoding: "ascii" });
    const fileValidationRe = /^(\d+\s\d+(\r\n|\r|\n))+$/;
    if (!fileValidationRe.test(fileString)) {
        throw new TypeError("Initial state file must satisfy regular expression ^(\\d+\\s\\d+(\\r\\n|\\r|\\n))+$.");
    }
    fileString.split(/\r?\n/).forEach(line => {
        if (line !== "") board.set(...line.split(' ').map(coord => parseInt(coord)));
    });

    for (let timestep = 0; timestep < args.numTimesteps; timestep++) {
        // Save file
        saveBoardAsPBMP1(board, `${timestep}.pbm`);

        // Compute next step
        next = new Board(args.boardSize);
        for (let row = 0; row < args.boardSize; row++) {
            for (let col = 0; col < args.boardSize; col++) {
                const numNeighbors = getNumNeighbors(board, row, col);
                if (board.isSet(row, col)) {
                    if (2 <= numNeighbors && numNeighbors <= 3) next.set(row, col);
                } else {
                    if (numNeighbors === 3) next.set(row, col);
                }
            }
        }
        board = next;
    }
})()