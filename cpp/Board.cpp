#include "Board.hpp"

Board::Board(uint64_t size)
    : size{size}
{
    if (0 >= size) {
        throw std::runtime_error("Please provide a positive integer board size.");
    }
    this->board = std::vector(this->size, std::vector<bool>(this->size, false));
}

bool Board::isSet(uint64_t row, uint64_t col) const
{
    if (row < 0 || row >= this->size || col < 0 || col >= this->size) {
        throw std::runtime_error(std::format("{} or {} are out of bounds for board of size {}.", row, col, this->size));
    }
    return this->board.at(row).at(col);
}

void Board::set(uint64_t row, uint64_t col)
{
    if (row < 0 || row >= this->size || col < 0 || col >= this->size) {
        throw std::runtime_error(std::format("{} or {} are out of bounds for board of size {}.", row, col, this->size));
    }
    this->board.at(row).at(col) = true;
}

const uint64_t& Board::getSize() const {
    return this->size;
}