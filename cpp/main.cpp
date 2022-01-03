#include <iostream>
#include <fstream>
#include <string>
#include <format>
#include "Board.hpp"

uint64_t getNumNeighbors(Board& board, uint64_t row, uint64_t col)
{
    uint64_t count{0};
    if (board.get((row-1) % board.size, (col-1) % board.size) == '1') count += 1;
    if (board.get((row-1) % board.size, (col  ) % board.size) == '1') count += 1;
    if (board.get((row-1) % board.size, (col+1) % board.size) == '1') count += 1;
    if (board.get((row  ) % board.size, (col-1) % board.size) == '1') count += 1;
    if (board.get((row  ) % board.size, (col+1) % board.size) == '1') count += 1;
    if (board.get((row+1) % board.size, (col-1) % board.size) == '1') count += 1;
    if (board.get((row+1) % board.size, (col  ) % board.size) == '1') count += 1;
    if (board.get((row+1) % board.size, (col+1) % board.size) == '1') count += 1;
    return count;
}

void saveBoardAsPBMP1(Board& board, std::string filename)
{
    std::ofstream f{filename};
    f << std::format("P1\n{} {}\n", board.size, board.size);
    for (uint64_t row{0}; row < board.size; row++) {
        for (uint64_t col{0}; col < board.size - 1; col++) {
            f << board.get(row, col) << " ";
        }
        f << board.get(row, board.size - 1) << "\n";
    }
}

int main(int argc, char* argv[])
{
    uint64_t size;
    uint64_t numTimesteps;
    std::string initial_state_filepath{"start.txt"};

    // Parse args
    switch(argc) {
        case 4: initial_state_filepath = argv[3];
        case 3:
            size = std::stoi(argv[1]);
            numTimesteps = std::stoi(argv[2]);
            break;
        default:
            std::cout << R"(
usage: main.py [-h] [--input file] size N       

Conway's Game of Life, in C++

positional arguments:
size          Side length of simulated board.
N             Number of timesteps to simulate.

optional arguments:
--input file  path to text file of board's initial state. default: ./start.txt
            )" << std::endl;
    }

    // Set up boards and time stuff
    Board b(size);
    uint64_t timestep{0};

    // Read in initial state
    std::ifstream f{initial_state_filepath};
    while (f) {
        std::string line;
        std::getline(f, line);
        std::string::size_type n = line.find(" ");
        if (n == std::string::npos) continue;

        uint64_t row = std::stoi(line.substr(0, n));
        uint64_t col = std::stoi(line.substr(n));
        b.set(row, col);
    }

    // Simulate next timestep and save image until simulation is done.
    while (timestep < numTimesteps) {
        saveBoardAsPBMP1(b, std::format("{}.pbm", timestep++));

        Board next(b.size);
        for (uint64_t row{0}; row < b.size; row++) {
            for (uint64_t col{0}; col < b.size; col++) {
                uint64_t numNeighbors = getNumNeighbors(b, row, col);
                // std::cout << numNeighbors << std::endl;
                if (b.get(row, col) == '1') {
                    if (2 <= numNeighbors && numNeighbors <= 3) next.set(row, col);
                } else {
                    if (numNeighbors == 3) next.set(row, col);
                }
            }
        }
        b = next;
    }
}