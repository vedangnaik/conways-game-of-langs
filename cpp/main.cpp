#include <iostream>
#include <fstream>
#include <string>
#include <format>
#include "Board.hpp"

uint64_t getNumNeighbors(Board& board, uint64_t row, uint64_t col)
{
    uint64_t count{ 0 };
    const uint64_t& size{ board.getSize() };

    uint64_t row_lower{ row - 1 };
    uint64_t row_upper{ row + 1 };
    uint64_t col_lower{ col - 1 };
    uint64_t col_upper{ col + 1 };

    if ((int64_t)(row - 1) == -1) row_lower = size - 1;
    if (row + 1 == size)          row_upper = 0;
    if ((int64_t)(col - 1) == -1) col_lower = size - 1;
    if (col + 1 == size)          col_upper = 0;

    if (board.isSet(row_lower % size, col_lower % size)) count += 1;
    if (board.isSet(row_lower % size, col       % size)) count += 1;
    if (board.isSet(row_lower % size, col_upper % size)) count += 1;
    if (board.isSet(row       % size, col_lower % size)) count += 1;
    if (board.isSet(row       % size, col_upper % size)) count += 1;
    if (board.isSet(row_upper % size, col_lower % size)) count += 1;
    if (board.isSet(row_upper % size, col       % size)) count += 1;
    if (board.isSet(row_upper % size, col_upper % size)) count += 1;
    return count;
}

void saveAsPBMP1(Board& board, std::string filename)
{
    const std::vector<std::vector<bool>>& b{ board.getBoard() };
    const uint64_t& size{ board.getSize() };

    std::ofstream f{filename};
    f << std::format("P1\n{} {}\n", size, size);
    for (uint64_t row{0}; row < size; row++) {
        for (uint64_t col{0}; col < size; col++) {
            f << std::format("{} ", b.at(row).at(col) ? '1' : '0');
        }
        f << "\n";
    }
}

int main(int argc, char* argv[])
{
    uint64_t size;
    uint64_t numTimesteps;
    std::string initial_state_filepath;

    // Parse args
    if (argc != 4) {
        std::cout << R"(
usage: main [-h] size N file

Conway's Game of Life, in C++

positional arguments:
  size        Side length of simulated board.
  N           Number of timesteps to simulate.
  file        path to text file of board's initial state.

optional arguments:
  -h, --help  show this help message and exit
        )" << std::endl;
        return -1;
    } else {
        size = (uint64_t)std::stoi(argv[1]);
        numTimesteps = (uint64_t)std::stoi(argv[2]);
        initial_state_filepath = std::string(argv[3]);
    }

    // Set up boards and time stuff
    Board board(size);
    uint64_t timestep{0};

    // Read in initial state
    std::ifstream f{initial_state_filepath};
    while (f) {
        std::string line;
        std::getline(f, line);
        std::string::size_type n{ line.find(" ") };
        if (n == std::string::npos) continue;

        uint64_t row = (uint64_t)std::stoi(line.substr(0, n));
        uint64_t col = (uint64_t)std::stoi(line.substr(n));
        board.set(row, col);
    }

    // Simulate next timestep and save image until simulation is done.
    while (timestep < numTimesteps) {
        saveAsPBMP1(board, std::format("{}.pbm", timestep++));

        Board next(size);
        for (uint64_t row{0}; row < size; row++) {
            for (uint64_t col{0}; col < size; col++) {
                uint64_t numNeighbors{ getNumNeighbors(board, row, col) };
                if (board.isSet(row, col)) {
                    if (2 <= numNeighbors && numNeighbors <= 3) next.set(row, col);
                } else {
                    if (numNeighbors == 3) next.set(row, col);
                }
            }
        }
        board = next;
    }
}