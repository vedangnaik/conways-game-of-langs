## Requirements
* **Java** - Any version with support for multiline strings, `MessageFormat`, etc. will do. This program has been tested with Java 17 only.
* **Maven** - At least version `3.8.1` or above.

## Build
```
$ git clone https://github.com/vedangnaik/conways_game_of_langs.git
$ cd conways_game_of_langs/java
$ mvn package
```

## Run
Simulate 500 turns of a game on a 25x25 board with initial state read from `test.txt`. Output images will be placed in the directory the command is run from.
```
$ java -cp target/main-1.0-SNAPSHOT.jar game_of_life.main.Main 25 500 test.txt
```
Full help text for reference:
```
$ java -cp target/main-1.0-SNAPSHOT.jar game_of_life.main.Main --help
usage: game_of_life.main.Main [-h] size N file

Conway's Game of Life, in Java

positional arguments:
  size        Side length of simulated board.
  N           Number of timesteps to simulate.
  file        path to text file of board's initial state.

optional arguments:
  -h, --help  show this help message and exit.
```