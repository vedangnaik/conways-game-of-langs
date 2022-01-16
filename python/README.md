## Install
* **Python 3.x** - Any version with support for f-strings, exceptions and `argparse`. This program has been tested with Python v3.9.5.

## Build
There is no build process.

## Run
Simulate 500 turns of a game on a 25x25 board with initial state read from `test.txt`. Output images will be placed in the directory the command is run from.
```
$ python main.py 25 500 test.txt
```
Full help text for reference:
```
$ python main.py --help
usage: main.py [-h] size N file

Conway's Game of Life, in Python

positional arguments:
  size        side length of simulated board
  N           number of timesteps to simulate
  file        path to text file of board's initial state

optional arguments:
  -h, --help  show this help message and exit
```