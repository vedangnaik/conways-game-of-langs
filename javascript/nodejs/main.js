const fs = require('fs');

class Board {
    #board;
    size;

    constructor(size) {
        this.size = size;
        this.#board = []
        for (let row = 0; row < size; row++) {
            this.#board.push([])
            for (let col = 0; col < size; col++) {
                this.#board[row].push(false)
            }
        }
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
    for (let row = 0; row < board.size; row++) {
        for (let col = 0; col < board.size; col++) {
            filestring += `${board.isSet(row, col) ? "1" : "0"} `;
        }
        filestring += "\n";
    }
    fs.writeFileSync(filename, filestring);
}

function getNumNeighbors(board, row, col) {
    if (!(0 <= row < board.size && 0 <= col < board.size)) {
        throw new RangeError(`${row} or ${col} are out of range for board with size ${this.size}`);
    }
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
    // Parse args
    let size;
    let numTimeSteps;
    let initialStateFilePath;

    const args = process.argv.slice(2);
    if (args.length != 3) {
        console.log(`usage: main.js [-h] size N file

Conway's Game of Life, in NodeJS

positional arguments:
size        Side length of simulated board.
N           Number of timesteps to simulate.
file        path to text file of board's initial state.

optional arguments:
-h, --help  show this help message and exit`);
        process.exit(-1);
    } else {
        size = parseInt(args[0]);
        if (isNaN(size) || size <= 0) {
            console.log(`'size' must be a valid positive integer.`);
            process.exit(-1);
        }

        numTimeSteps = parseInt(args[1]);
        if (isNaN(numTimeSteps) || numTimeSteps <= 0) {
            console.log(`'N' must be a valid positive integer.`);
            process.exit(-1);
        }

        initialStateFilePath = args[2];
        if (!fs.statSync(initialStateFilePath).isFile()) {
            console.log(`${initialStateFilePath} must be a valid file.`);
            process.exit(-1);
        }
    }

    // Set up board
    let board = new Board(size);

    // Read in initial state
    const fileString = fs.readFileSync(initialStateFilePath, { encoding: "ascii" });
    fileString.split(/\r?\n/).forEach(line => {
        const [row, col] = line.split(' ').map(coord => parseInt(coord));
        if (isNaN(row) || isNaN(col)) {
            console.log(`${initialStateFilePath} contains at least one malformed coordinate.`);
            process.exit(-1);
        }
        board.set(row, col);
    })

    for (let timestep = 0; timestep < numTimeSteps; timestep++) {
        // Save file
        saveBoardAsPBMP1(board, `${timestep}.pbm`);

        // Compute next step
        next = new Board(size);
        for (let row = 0; row < size; row++) {
            for (let col = 0; col < size; col++) {
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