## Install
* **C++ toolchain** - Any toolchain supporting C++20.
* **CMake** - Version 3.10 or greater. An Internet connection is required for `FetchContent` to download the `argparse` dependency.

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
$ ./main -h
Usage: main [options] board_size num_iterations initial_state_file

Positional arguments:
board_size              side length of simulated current
num_iterations          number of iterations to simulate
initial_state_file      path to text file of current's initial state

Optional arguments:
-h --help               shows help message and exits
-v --version            prints version information and exits
```