## Requirements
* **C++ toolchain** - Any toolchain supporting C++20.
* **CMake** - Version 3.10 or greater.

## Build
```
$ git clone https://github.com/vedangnaik/conways_game_of_langs.git
$ cd conways_game_of_langs/cpp
$ mkdir build && cd build
$ cmake -S .. -B .
$ cmake --build .
```

## Run
Simulate 500 turns of a game on a 25x25 board with initial state read from `test.txt`. Output images will be placed in the directory the command is run from.
```
$ ./main 25 500 test.txt
```
Full help text for reference:
```
$ ./main --help
usage: main [-h] size N file

Conway's Game of Life, in C++

positional arguments:
  size        Side length of simulated board.
  N           Number of timesteps to simulate.
  file        path to text file of board's initial state.

optional arguments:
  -h, --help  show this help message and exit
```