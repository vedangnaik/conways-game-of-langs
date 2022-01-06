## Requirements
* **NodeJS** - Any version with support for `Error`s, template strings, etc. This program has been tested with Node v17.3.0.

## Build
There is no build process.

## Run
Simulate 500 turns of a game on a 25x25 board with initial state read from `test.txt`. Output images will be placed in the directory the command is run from.
```
$ node main.js 25 500 test.txt
```
Full help text for reference:
```
$ node main.js --help
usage: main.js [-h] size N file

Conway's Game of Life, in NodeJS

positional arguments:
size        Side length of simulated board.
N           Number of timesteps to simulate.
file        path to text file of board's initial state.

optional arguments:
-h, --help  show this help message and exit
```