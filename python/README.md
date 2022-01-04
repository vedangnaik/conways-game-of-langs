## Requirements
* **Python 3.x** - Any version with support for f-strings, exceptions and `argparse` will do.

## Build
There is no build process

## Run
Simulate 500 turns of a game on a 25x25 board with initial state read from `test.txt`. Output images will be placed in the directory the command is run from.
```
$ python main.py 25 500 --input test.txt
```
Full help text for reference:
```
$ python main.py --help
usage: main.py [-h] [--input file] size N

Conway's Game of Life, in Python

positional arguments:
  size          Side length of simulated board.
  N             Number of timesteps to simulate.

optional arguments:
  -h, --help    show this help message and exit
  --input file  path to text file of board's initial state. default: ./start.txt
```