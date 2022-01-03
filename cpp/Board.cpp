#include "Board.hpp"

Board::Board(uint64_t size)
    : size{size}, board(size, std::vector<uint8_t>(size, '0'))
{   
}

uint8_t Board::get(uint64_t row, uint64_t col)
{
    return this->board.at(row).at(col);
}

void Board::set(uint64_t row, uint64_t col)
{
    this->board.at(row).at(col) = '1';
}