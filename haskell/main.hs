import Text.Regex.TDFA ( (=~) )
import System.Environment ( getArgs )
import Text.Read ( readMaybe )
import Data.Maybe ( fromJust, isJust )
import Control.Applicative (optional)

data ArgParseResult = Help | Err | OK Int Int FilePath deriving Show

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
            else Err
    | otherwise = Err

main :: IO ()
main = do
    args <- getArgs
    let result = parseArgs args
    case result of
        Help -> putStrLn "help message here"
        Err -> putStrLn "error message here"
        OK size n file -> do
            r <- optional $ readFile file
            case r of
                -- Just contents -> putStr contents
                Just contents -> putStrLn $ (contents =~ "\\`([0-9]+ [0-9]+(\r\n|\r|\n))+\\'" :: String)
                Nothing -> putStrLn "file doesn't exist"