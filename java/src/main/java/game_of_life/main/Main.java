package game_of_life.main;

import java.io.File;
import java.io.IOException;
import java.io.PrintWriter;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.Path;
import java.text.MessageFormat;
import java.util.regex.Pattern;

import net.sourceforge.argparse4j.ArgumentParsers;
import net.sourceforge.argparse4j.inf.ArgumentParser;
import net.sourceforge.argparse4j.inf.ArgumentParserException;
import net.sourceforge.argparse4j.inf.Namespace;

public class Main
{
    private static void saveBoardAsPBMP1(Board board, String filename) {
        try {
            PrintWriter p = new PrintWriter(filename);
            p.write(MessageFormat.format("P1\n{0} {1}\n", board.size, board.size));
            for (int row = 0; row < board.size; row++) {
                for (int col = 0; col < board.size; col++) {
                    p.write(MessageFormat.format("{0} ", board.isSet(row, col) ? "1" : "0"));
                }
                p.write("\n");
            }
            p.close();
        } catch (IOException ignored) {}
    }

    private static int getNumNeighbors(Board board, int row, int col) {
        int count = 0;
        if (board.isSet(Math.floorMod(row - 1, board.size), Math.floorMod(col - 1, board.size))) count += 1;
        if (board.isSet(Math.floorMod(row - 1, board.size), Math.floorMod(col    , board.size))) count += 1;
        if (board.isSet(Math.floorMod(row - 1, board.size), Math.floorMod(col + 1, board.size))) count += 1;
        if (board.isSet(Math.floorMod(row    , board.size), Math.floorMod(col - 1, board.size))) count += 1;
        if (board.isSet(Math.floorMod(row    , board.size), Math.floorMod(col + 1, board.size))) count += 1;
        if (board.isSet(Math.floorMod(row + 1, board.size), Math.floorMod(col - 1, board.size))) count += 1;
        if (board.isSet(Math.floorMod(row + 1, board.size), Math.floorMod(col    , board.size))) count += 1;
        if (board.isSet(Math.floorMod(row + 1, board.size), Math.floorMod(col + 1, board.size))) count += 1;
        return count;
    }

    public static void main(String[] args)
    {
        ArgumentParser parser = ArgumentParsers.newFor("game_of_life.main.Main").build()
                .defaultHelp(true)
                .description("Conway's Game of Life, in Java");
        parser.addArgument("boardSize")
                .type(Integer.class)
                .help("side length of simulated board.")
                .metavar("size");
        parser.addArgument("numIterations")
                .type(Integer.class)
                .help("number of iterations to simulate.")
                .metavar("N");
        parser.addArgument("initialStateFile")
                .type(File.class)
                .help("path to text file of board's initial state.")
                .metavar("file");
        Namespace ns = null;
        try {
            ns = parser.parseArgs(args);
        } catch (ArgumentParserException e) {
            parser.handleError(e);
            System.exit(1);
        }
        int userBoardSize = ns.getInt("boardSize");
        int userNumIterations = ns.getInt("numIterations");
        String userInitialStateFilepath = ns.getString("initialStateFile");

        // Update board with initial state
        Board current = null;
        try {
            current = new Board(userBoardSize);

            String fileStr = Files.readString(Path.of(userInitialStateFilepath), StandardCharsets.UTF_8);
            if (!Pattern.compile("^(\\d+\\s\\d+(\\r\\n|\\r|\\n))+$").matcher(fileStr).matches()) {
                throw new Exception(MessageFormat.format("Initial state file {0} must satisfy regular expression ^(\\d+\\s\\d+(\\r\\n|\\r|\\n))+$.", userInitialStateFilepath));
            }

            for (String s : fileStr.split("(\\r\\n|\\r|\\n)")) {
                String[] parts = s.split(" ");
                int row = Integer.parseInt(parts[0]);
                int col = Integer.parseInt(parts[1]);
                current.set(row, col);
            }
        } catch (Exception e) {
            System.out.println(e.getMessage());
            System.exit(1);
        }

        // Simulate requested number of iterations
        for (int iteration = 0; iteration < userNumIterations; iteration++) {
            saveBoardAsPBMP1(current, MessageFormat.format("{0}.pbm", iteration));

            Board next = new Board(current.size);
            for (int row = 0; row < current.size; row++) {
                for (int col = 0; col < current.size; col++) {
                    int numNeighbors = getNumNeighbors(current, row, col);
                    if (current.isSet(row, col)) {
                        if (2 <= numNeighbors && numNeighbors <= 3) next.set(row, col);
                    } else {
                        if (numNeighbors == 3) next.set(row, col);
                    }
                }
            }
            current = next;
        }
    }
}
