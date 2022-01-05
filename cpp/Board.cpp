#include "Board.hpp"

Board::Board(uint64_t size)
    : size{size}, board(size, std::vector<bool>(size, false))
{
}

bool Board::isSet(uint64_t row, uint64_t col)
{
    return this->board.at(row).at(col);
}

void Board::set(uint64_t row, uint64_t col)
{
    this->board.at(row).at(col) = true;
}

const std::vector<std::vector<bool>>& Board::getBoard()
{
    return this->board;
}

const uint64_t& Board::getSize() {
    return this->size;
}