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

data Board = Board { _m :: Map [Int] Bool, _size :: Int}
instance Show Board where
    show (Board m size) =
        intercalate "\n" $ map rowToStr [0..size - 1]
        where
            rowToStr :: Int -> String
            rowToStr y = unwords $ map (\x -> if member [y, x] m then "1" else "0") [0..size - 1]

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

nextBoard :: Board -> Board
nextBoard (Board m s) = Board m s

makeBoard :: [[Int]] -> Int -> Board
makeBoard coords = Board (foldr insertCoord empty coords)
    where
        insertCoord :: [Int] -> Map [Int] Bool -> Map [Int] Bool
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
                        boards = scanr (\_ board -> nextBoard board) (makeBoard coords size) [1..n-1]
                        writes = mapWithIndex (\i board -> saveBoardAsPBMP1 (show i ++ ".pbm") board) $ fromList boards
                    sequence_ writes
                else
                    ioError $ userError "out of bounds"
            else ioError $ userError "file format wrong"
    ) handler
    where
        handler :: IOError -> IO ()
        handler e = print e