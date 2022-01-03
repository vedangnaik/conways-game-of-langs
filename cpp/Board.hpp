#include <vector>

class Board {
public:
    Board(uint64_t size);
    uint8_t get(uint64_t row, uint64_t col);
    void set(uint64_t row, uint64_t col);

    uint64_t size;
private:
    std::vector<std::vector<uint8_t>> board;
};