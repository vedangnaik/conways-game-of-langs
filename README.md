# Conway's Game of Langs
Conway's Game of Life in as many languages as I know.

## Structure
Each folder in this repository contains a standardized implementation of Conway's Game of Life in the corresponding langauge. This implementation
* Takes as input on the command line
    - one positive integer for the square's board size,
    - one integer for the number of timesteps to simulate,
    - and one string filepath for the file containing the game's initial state,
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
2. Depending on your operating system, use
    - Windows: `make_video.ps1`

to generate the final video.