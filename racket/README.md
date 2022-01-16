## Install
* **Racket** - Any sufficiently recent version with support for `racket/cmdline`. This program has been tested with Racket v8.3.

## Build
There is no build process.

## Run
Simulate 500 turns of a game on a 25x25 board with initial state read from `test.txt`. Output images will be placed in the directory the command is run from.
```
$ racket main.rkt 25 500 test.txt
```
Full help text for reference:
```
$ racket main.rkt -h
usage: main [ <option> ... ] <board-size> <simulation-timesteps> <inital-state-file>

<option> is one of

  --help, -h
     Show this help
  --
     Do not treat any remaining argument as a switch (at this level)

 Multiple single-letter switches can be combined after
 one `-`. For example, `-h-` is the same as `-h --`.
```