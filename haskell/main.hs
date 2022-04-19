{-# OPTIONS_GHC -Wall #-}

import Text.Regex.TDFA ((=~))
import System.Environment (getArgs)
import Text.Read (readMaybe )
import Data.Maybe (fromJust, isJust)
import System.IO.Error ()
import Control.Exception (catch)
import Data.Map (empty, Map, insert, member)
import Control.Monad ()
import Data.List (intercalate)
import Data.Sequence (mapWithIndex, fromList)

data ArgParseResult = Help | OK Int Int FilePath deriving Show

data Board = Board { _m :: Map (Int, Int) Bool, _size :: Int}
instance Show Board where
    show (Board m size) =
        intercalate "\n" $ map rowToStr [0..size - 1]
        where
            rowToStr :: Int -> String
            rowToStr y = unwords $ map (\x -> if member (y, x) m then "1" else "0") [0..size - 1]

parseArgs :: [String] -> ArgParseResult
parseArgs args
    | length args == 1 && head args == "-h" = Help
    | length args == 3 =
        let
            size = readMaybe (head args) :: Maybe Int
            n = readMaybe (args !! 1) :: Maybe Int
            file = (args !! 2)
        in
            if isJust size && isJust n then
                OK (fromJust size) (fromJust n) file
            else Help
    | otherwise = Help

tuplify :: [Int] -> (Int, Int)
tuplify l = (head l, l !! 1)

getNumNeighbors :: Board -> (Int, Int) -> Int
getNumNeighbors (Board m size) (x, y) =
    let
        neighbors = [
            ((x - 1) `mod` size, (y - 1) `mod` size),
            (x       `mod` size, (y - 1) `mod` size),
            ((x + 1) `mod` size, (y - 1) `mod` size),
            ((x - 1) `mod` size, y       `mod` size),
            ((x + 1) `mod` size, y       `mod` size),
            ((x - 1) `mod` size, (y + 1) `mod` size),
            (x       `mod` size, (y + 1) `mod` size),
            ((x + 1) `mod` size, (y + 1) `mod` size)]
    in
        sum $ map (\neighbor -> if member neighbor m then 1 else 0) neighbors

nextBoard :: Board -> Board
nextBoard (Board m size) =
    Board (foldr applyGameOfLifeRules empty coords) size
    where
        coords = [(x, y) | x <- [0..size - 1], y <- [0..size - 1]]
        applyGameOfLifeRules :: (Int, Int) -> Map (Int, Int) Bool -> Map (Int, Int) Bool
        applyGameOfLifeRules coord newM =
            let
                numNeighbors = getNumNeighbors (Board m size) coord
            in
                if (not (member coord m) && numNeighbors == 3) || (member coord m  && (numNeighbors == 2 || numNeighbors == 3)) 
                    then insert coord True newM 
                else newM

makeBoard :: [(Int, Int)] -> Int -> Board
makeBoard coords = Board (foldr insertCoord empty coords)
    where
        insertCoord :: (Int, Int) -> Map (Int, Int) Bool -> Map (Int, Int) Bool
        insertCoord coord board = insert coord True board

saveBoardAsPBMP1 :: FilePath -> Board -> IO ()
saveBoardAsPBMP1 filepath board =
    writeFile filepath $ "P1\n" ++ show (_size board) ++ " " ++ show (_size board) ++ "\n" ++ show board

main :: IO ()
main = catch (do
    args <- getArgs
    let result = parseArgs args
    case result of
        Help -> putStrLn "help message here"
        OK size n file -> do
            contents <- readFile file
            if contents =~ "\\`([0-9]+ [0-9]+(\r\n|\r|\n))+\\'" :: Bool then do
                let coords = map (map (read :: String -> Int) . words) . lines $ contents
                if not (any ((not . null) . filter (> size)) coords) then do
                    let
                        boards :: [Board]
                        boards = scanl (\board _ -> nextBoard board) (makeBoard (map tuplify coords) size) [1..n-1]
                        writes = mapWithIndex (\i board -> saveBoardAsPBMP1 (show i ++ ".pbm") board) $ fromList boards
                    sequence_ writes
                else
                    ioError $ userError "out of bounds"
            else ioError $ userError "file format wrong"
    ) handler
    where
        handler :: IOError -> IO ()
        handler = print