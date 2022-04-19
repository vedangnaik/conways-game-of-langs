# Conway's Game of Langs
Conway's Game of Life in as many languages as I know.

## Structure
Each folder in this repository contains a standardized implementation of Conway's Game of Life in the corresponding langauge. This implementation
* takes as input on the command line
    - one positive integer for the square's board size,
    - one integer for the number of timesteps to simulate,
    - and one string filepath for the file containing the game's initial state (the contents of which must match the regex `^(\d+\s\d+(\r\n|\r|\n))+$`, where 
        * `\d` is any digit from 0 through 9, 
        * `\s` is a single space, 
        * `\r` is the carraige return character, 
        * `\n` is the newline character, 
        * `+` means "one or more of",
        * `|` means "either one of",
        * `^` indicates the start of the string,
        * `$` indicates the end of the string, and
        * `()` indicate a capture group)
* and outputs
    - one PBM P1 (i.e. greyscale, ASCII; see https://en.wikipedia.org/wiki/Netpbm#PBM_example) image for each timestep, representing the state of the board at that timestep.

Each output image is then converted to JPEG and scaled up 200x with `ImageMagick`, then stiched into a video with `ffmpeg`.

*Note: The algoritm is naive; do not expect to be able to calculate quadrillions of timesteps.*

## Usage

### Requirements
* `ImageMagick`: On PATH. Download from https://imagemagick.org/script/download.php.
* `ffmpeg`: On PATH: Download from https://www.ffmpeg.org/download.html.

### Build
Follow the instructions in the `README.md` of the language you wish to use.

### Run
1. Follow the instructions in the `README.md` of the language you wish to use.
2. Depending on your operating system, run the following command from within the directory the images were generated:
    - Windows: `make_video.ps1 .`

The final video `out.mp4` will be generated in this directory. Enjoy!

## Test Statuses
[![C++](https://github.com/vedangnaik/conways_game_of_langs/actions/workflows/cpp_tests.yml/badge.svg)](https://github.com/vedangnaik/conways_game_of_langs/actions/workflows/cpp_tests.yml)

[![Haskell](https://github.com/vedangnaik/conways_game_of_langs/actions/workflows/haskell_tests.yml/badge.svg)](https://github.com/vedangnaik/conways_game_of_langs/actions/workflows/haskell_tests.yml)

[![Java](https://github.com/vedangnaik/conways_game_of_langs/actions/workflows/java_tests.yml/badge.svg)](https://github.com/vedangnaik/conways_game_of_langs/actions/workflows/java_tests.yml)

[![JavaScript NodeJS](https://github.com/vedangnaik/conways_game_of_langs/actions/workflows/javascript_nodejs_tests.yml/badge.svg)](https://github.com/vedangnaik/conways_game_of_langs/actions/workflows/javascript_nodejs_tests.yml)

[![Python](https://github.com/vedangnaik/conways_game_of_langs/actions/workflows/python_tests.yml/badge.svg)](https://github.com/vedangnaik/conways_game_of_langs/actions/workflows/python_tests.yml)

[![Racket](https://github.com/vedangnaik/conways_game_of_langs/actions/workflows/racket_tests.yml/badge.svg)](https://github.com/vedangnaik/conways_game_of_langs/actions/workflows/racket_tests.yml)