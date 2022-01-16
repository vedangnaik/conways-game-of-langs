## Install
* **node** - Any version with support for `Error`s, template strings, etc. This program has been tested with Node v17.3.0.
* **npm** - Any sufficiently up-to-date version. This program has been tested with npm v8.3.0.

## Build
```
$ git clone https://github.com/vedangnaik/conways_game_of_langs.git
$ cd conways_game_of_langs/javascript/nodejs
$ npm i
```

## Run
Simulate 500 turns of a game on a 25x25 board with initial state read from `test.txt`. Output images will be placed in the directory the command is run from.
```
$ node main.js 25 500 test.txt
```
Full help text for reference:
```
$ node main.js --help
usage: main.js [-h] boardSize numTimesteps initialStateFile

Conway's Game of Life, in NodeJS

positional arguments:
  boardSize         Side length of simulated board.
  numTimesteps      Number of timesteps to simulate.
  initialStateFile  Path to text file of board's initial state.

optional arguments:
  -h, --help        show this help message and exit
```