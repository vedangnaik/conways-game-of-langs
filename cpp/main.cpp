#include <iostream>
#include <fstream>
#include <string>
#include <format>
#include <iterator>
#include <regex>
#include <sstream>
#include <memory>
#include "Board.hpp"
#include <argparse/argparse.hpp>

uint64_t getNumNeighbors(const Board& board, const uint64_t row, const uint64_t col)
{
    uint64_t count{0};
    const uint64_t& size{board.getSize()};

    uint64_t row_lower{row - 1};
    uint64_t row_upper{row + 1};
    uint64_t col_lower{col - 1};
    uint64_t col_upper{col + 1};

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

void saveAsPBMP1(const Board& board, const std::string& filename)
{
    const uint64_t& size{board.getSize()};
    std::ofstream f{filename};
    f << std::format("P1\n{} {}\n", size, size);
    for (uint64_t row{0}; row < size; row++) {
        for (uint64_t col{0}; col < size; col++) {
            f << std::format("{} ", board.isSet(row, col) ? '1' : '0');
        }
        f << "\n";
    }
}

int main(int argc, char* argv[])
{
    argparse::ArgumentParser parser("main", "1.0.0");
    parser.add_argument("board_size")
        .help("side length of simulated current")
        .scan<'i', uint64_t>();
    parser.add_argument("num_iterations")
        .help("number of iterations to simulate")
        .scan<'i', uint64_t>();
    parser.add_argument("initial_state_file")
        .help("path to text file of current's initial state");

    try {
        parser.parse_args(argc, argv);
    }
    catch (const std::runtime_error& err) {
        std::cerr << err.what() << std::endl;
        std::exit(1);
    }

    auto user_board_size = parser.get<uint64_t>("board_size");
    auto user_num_iterations = parser.get<uint64_t>("num_iterations");
    auto user_initial_state_filepath = parser.get<std::string>("initial_state_file");

    auto current{std::make_unique<Board>(user_board_size)};
    // Read in initial state
    std::ifstream f{user_initial_state_filepath};
    if (f.fail()) {
        throw std::runtime_error(std::format("Initial state file {} does not exist or could not be opened.", user_initial_state_filepath));
    }
    // Validate file shape
    std::string fileStr(std::istreambuf_iterator<char>{f}, {});
    std::regex fileValidatorRe("^(\\d+\\s\\d+(\r\n|\r|\n))+$");
    std::smatch m;
    if (!std::regex_match(fileStr, m, fileValidatorRe)) {
        throw std::runtime_error(std::format("Initial state file {} must satisfy regular expression ^(\\d+\\s\\d+(\\r\\n|\\r|\\n))+$.", user_initial_state_filepath));
    }
    // Extract coordinates
    std::stringstream ss(fileStr);
    for (std::string line; std::getline(ss, line); ) {
        std::string::size_type n{ line.find(' ') };
        uint64_t row = (uint64_t)std::stoi(line.substr(0, n));
        uint64_t col = (uint64_t)std::stoi(line.substr(n));
        current->set(row, col);
    }

    // Simulate next iteration and save image until simulation is done.
    for (uint64_t iteration = 0; iteration < user_num_iterations; iteration++) {
        saveAsPBMP1(*current, std::format("{}.pbm", iteration));

        auto next{std::make_unique<Board>(current->getSize())};
        for (uint64_t row{0}; row < current->getSize(); row++) {
            for (uint64_t col{0}; col < current->getSize(); col++) {
                uint64_t numNeighbors{getNumNeighbors(*current, row, col)};
                if (current->isSet(row, col)) {
                    if (2 <= numNeighbors && numNeighbors <= 3) next->set(row, col);
                } else {
                    if (numNeighbors == 3) next->set(row, col);
                }
            }
        }
        current.swap(next);
    }
}