#include <vector>

class Board {
public:
    Board(uint64_t size);
    bool isSet(uint64_t row, uint64_t col);
    void set(uint64_t row, uint64_t col);
    const std::vector<std::vector<bool>>& getBoard();
    const uint64_t& getSize();

private:
    uint64_t size;
    std::vector<std::vector<bool>> board;
};