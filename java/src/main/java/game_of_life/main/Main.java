package game_of_life.main;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.text.MessageFormat;

public class Main
{
    public static void main(String[] args)
    {
        // Parse args
        int size;
        int numTimesteps;
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
                numTimesteps = Integer.parseInt(args[1]);
                initialStateFilepath = args[2];
            } catch (NumberFormatException e) {
                System.out.println(e.getMessage());
                return;
            }
        }

        // Set up board and simulation stuff
        boolean[][] board;
        int timestep = 0;

        // Read in intial state
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

        // Simulate requested number of timesteps
        while (timestep < numTimesteps) {
            // TODO Save file
            timestep += 1;

            // Update board
            boolean[][] next = new boolean[size][size];
            for (var row : next) { for (var i : row) { i = false; }}
            for (int row = 0; row < size; row++) {
                for (int col = 0; col < size; col++) {
                    // TODO Calculate num neighbors
                    if (board[row][col]) {
                        // TODO
                    } else {
                        // TODO
                    }
                }
            }
            board = next;
        }
    }
}
