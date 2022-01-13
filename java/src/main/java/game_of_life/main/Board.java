package game_of_life.main;

import java.text.MessageFormat;

public class Board
{
    public final int size;
    private boolean[][] b;

    public Board(int size) {
        if (!(0 < size)) {
            throw new NegativeArraySizeException("Please provide a positive integer board size.");
        }

        this.size = size;
        this.b = new boolean[size][size];
        for (var row : this.b) {
            for (var i : row) { 
                i = false; 
            }
        }
    }

    public void set(int row, int col) {
        if (row < 0 || row >= this.size || col < 0 || col >= this.size) {
            throw new ArrayIndexOutOfBoundsException(MessageFormat.format("{0} or {1} are out of bounds for board of size {2}.", row, col, this.size));
        }
        this.b[row][col] = true;
    }

    public boolean isSet(int row, int col) {
        if (row < 0 || row >= this.size || col < 0 || col >= this.size) {
            throw new ArrayIndexOutOfBoundsException(MessageFormat.format("{0} or {1} are out of bounds for board of size {2}.", row, col, this.size));
        }
        return this.b[row][col];
    }
}