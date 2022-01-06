package game_of_life.main;

import java.io.IOException;
import java.io.PrintWriter;
import java.nio.file.Files;
import java.nio.file.Path;
import java.text.MessageFormat;

public class Main
{
    private static void saveBoardAsPBMP1(boolean[][] board, int size, String filename) {
        try {
            PrintWriter p = new PrintWriter(filename);
            p.write(MessageFormat.format("P1\n{0} {1}\n", size, size));
            for (var row : board) {
                for (var i : row) {
                    p.write(MessageFormat.format("{0} ", i ? "1" : "0"));
                }
                p.write("\n");
            }
            p.close();
        } catch (IOException ignored) {}
    }

    private static int getNumNeighbors(boolean[][] board, int size, int row, int col) {
        int count = 0;
        if (board[Math.floorMod(row - 1, size)][Math.floorMod(col - 1, size)]) count += 1;
        if (board[Math.floorMod(row - 1, size)][Math.floorMod(col    , size)]) count += 1;
        if (board[Math.floorMod(row - 1, size)][Math.floorMod(col + 1, size)]) count += 1;
        if (board[Math.floorMod(row    , size)][Math.floorMod(col - 1, size)]) count += 1;
        if (board[Math.floorMod(row    , size)][Math.floorMod(col + 1, size)]) count += 1;
        if (board[Math.floorMod(row + 1, size)][Math.floorMod(col - 1, size)]) count += 1;
        if (board[Math.floorMod(row + 1, size)][Math.floorMod(col    , size)]) count += 1;
        if (board[Math.floorMod(row + 1, size)][Math.floorMod(col + 1, size)]) count += 1;
        return count;
    }

    public static void main(String[] args)
    {
        // Parse args
        int size;
        int numTimeSteps;
        String initialStateFilepath;

        if (args.length != 3) {
            System.out.println("""
            usage: game_of_life.main.Main [-h] size N file
                    
            Conway's Game of Life, in Java
            
            positional arguments:
              size        Side length of simulated board.
              N           Number of timesteps to simulate.
              file        path to text file of board's initial state.
            
            optional arguments:
              -h, --help  show this help message and exit.
            """);
            return;
        } else {
            try {
                size = Integer.parseInt(args[0]);
                numTimeSteps = Integer.parseInt(args[1]);
                initialStateFilepath = args[2];
            } catch (NumberFormatException e) {
                System.out.println(e.getMessage());
                return;
            }
        }

        // Set up board and simulation stuff
        boolean[][] board;
        int timeStep = 0;

        // Read in initial state
        try {
            boolean[][] finalBoard = new boolean[size][size];
            for (var row : finalBoard) { for (var i : row) { i = false; }}
            Files.lines(Path.of(initialStateFilepath)).forEach(line -> {
                String[] parts = line.split(" ");
                int row = Integer.parseInt(parts[0]);
                int col = Integer.parseInt(parts[1]);
                if (row < 0 || row >= size || col < 0 || col >= size) throw new ArrayIndexOutOfBoundsException(MessageFormat.format("{0} or {1} are out of bounds for board of size {2}", row, col, size));
                finalBoard[row][col] = true;
            });
            board = finalBoard;
        } catch (IOException e) {
            System.out.println(MessageFormat.format("{0} is not a valid file.", initialStateFilepath));
            return;
        } catch (NumberFormatException e) {
            System.out.println(MessageFormat.format("{0} has an malformed coordinate.", initialStateFilepath));
            return;
        } catch (ArrayIndexOutOfBoundsException e) {
            System.out.println(e.getMessage());
            return;
        }

        // Simulate requested number of time steps
        while (timeStep < numTimeSteps) {
            saveBoardAsPBMP1(board, size, MessageFormat.format("{0}.pbm", timeStep));
            timeStep += 1;

            // Update board
            boolean[][] next = new boolean[size][size];
            for (var row : next) { for (var i : row) { i = false; }}
            for (int row = 0; row < size; row++) {
                for (int col = 0; col < size; col++) {
                    int numNeighbors = getNumNeighbors(board, size, row, col);
                    if (board[row][col]) {
                        if (2 <= numNeighbors && numNeighbors <= 3) next[row][col] = true;
                    } else {
                        if (numNeighbors == 3) next[row][col] = true;
                    }
                }
            }
            board = next;
        }
    }
}
