#include <vector>
#include <stdexcept>
#include <format>

class Board {
public:
    explicit Board(uint64_t size);
    [[nodiscard]] bool isSet(uint64_t row, uint64_t col) const;
    void set(uint64_t row, uint64_t col);
    [[nodiscard]] const uint64_t& getSize() const;

private:
    const uint64_t size;
    std::vector<std::vector<bool>> board;
};