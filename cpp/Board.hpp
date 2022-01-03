#include <vector>

class Board {
public:
    Board(uint64_t size);
private:
    std::vector<std::vector<uint8_t>> board;
};