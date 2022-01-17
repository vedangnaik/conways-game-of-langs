## Install
* **Java** - Any sufficiently recent version with support for multiline strings, `MessageFormat`, etc. will do. This program has been tested with Java 17.
* **Maven** - Any sufficiently recent version with support for `Argparse4j`. This program has been tested with Maven v3.8.1.

## Build
```
$ git clone https://github.com/vedangnaik/conways_game_of_langs.git
$ cd conways_game_of_langs/java
$ mvn package
```

## Run
Simulate 500 turns of a game on a 25x25 board with initial state read from `test.txt`. Output images will be placed in the directory the command is run from.
```
$ java -jar target/main-1.0-SNAPSHOT.jar 25 500 test.txt
```
Full help text for reference:
```
$ java -jar target/main-1.0-SNAPSHOT.jar -h
usage: game_of_life.main.Main [-h] size N file

Conway's Game of Life, in Java

positional arguments:
  size                   side length of simulated board.
  N                      number of iterations to simulate.
  file                   path to text file of board's initial state.

named arguments:
  -h, --help             show this help message and exit
```