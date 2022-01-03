#include "Board.hpp"

Board::Board(uint64_t size) {
    std::vector<std::vector<uint8_t>> t(size, std::vector<uint8_t>(size, 0));
    this->board = t;
}