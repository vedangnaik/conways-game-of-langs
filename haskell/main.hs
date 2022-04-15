import Text.Regex.TDFA ((=~))
import System.Environment (getArgs)
import Text.Read (readMaybe )
import Data.Maybe (fromJust, isJust)
import Control.Applicative (optional)
import System.IO.Error ()
import Control.Exception (catch)
import Data.Map (empty, Map, insert, member)
import Control.Monad ()
import Control.Monad.State (execState)
import Data.List (intercalate)
import Data.Sequence (mapWithIndex, fromList)

data ArgParseResult = Help | OK Int Int FilePath deriving Show

data Board = Board { m :: (Map [Int] Bool), size :: Int}
instance Show Board where
    show (Board m size) = 
        intercalate "\n" $ map (\y -> rowToStr y) [0..size - 1]
        where
            rowToStr :: Int -> String
            rowToStr y = unwords $ map (\x -> if member [y, x] m then "1" else "0") [0..size - 1]

parseArgs :: [String] -> ArgParseResult
parseArgs args
    | length args == 1 && head args == "-h" = Help
    | length args == 3 = 
        let 
            size = readMaybe (args !! 0) :: Maybe Int
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
makeBoard coords size = 
    Board (foldr insertCoord empty coords) size
    where 
        insertCoord :: [Int] -> Map [Int] Bool -> Map [Int] Bool
        insertCoord coord board = insert coord True board

saveBoardAsPBMP1 :: FilePath -> Board -> IO ()
saveBoardAsPBMP1 filepath board = 
    writeFile filepath $ "P1\n" ++ (show $ size board) ++ " " ++ (show $ size board) ++ "\n" ++ show board

main :: IO ()
main = catch (do
    args <- getArgs
    let result = parseArgs args
    case result of
        Help -> putStrLn "help message here"
        OK size n file -> do
            contents <- readFile file
            if contents =~ "\\`([0-9]+ [0-9]+(\r\n|\r|\n))+\\'" :: Bool then do
                let coords = map (map (read :: String -> Int)) . map words . lines $ contents
                if length (filter (\l -> length l /= 0) (map (filter (> size)) coords)) == 0 then do
                    let 
                        boards :: [Board]
                        boards = scanr (\_ board -> nextBoard board) (makeBoard coords size) [1..n-1]
                        writes = mapWithIndex (\i board -> saveBoardAsPBMP1 (show i ++ ".pbm") board) $ fromList boards
                    sequence writes
                    return ()
                else
                    ioError $ userError "out of bounds"
            else ioError $ userError "file format wrong"
    ) handler
    where
        handler :: IOError -> IO ()
        handler e = putStrLn $ show e