{-# LANGUAGE OverloadedStrings #-}
module ResponseHandling
    ( writeParsedTextToFile
    , writeJsonResponseToFile
    ) where

import Data.Aeson
import qualified Data.Text as T
import Network.HTTP.Req
import System.IO
import Text.Show.Unicode
import qualified Data.Vector as V
import Data.Aeson.Types

writeJsonResponseToFile :: FilePath -> Value -> IO ()
writeJsonResponseToFile file response = writeFile file $ ushow response

writeParsedTextToFile :: FilePath -> Value -> IO ()
writeParsedTextToFile file response = writeFile file $ ushowLn $
    showStyleNewlines $ parse fullParseParsedText response

-- | The array it's in is an array of objects and this is afield in that innner
-- object. Get the parsedText field out of the object.
parseText :: Value -> Parser T.Text
parseText = withObject "Object within ParsedResults" $ \o -> o .: "ParsedText"

-- | Get the ParsedResults field (which is array) from the json response.
parseParsedResults :: Value -> Parser Value -- Soo arrays have type Value.
parseParsedResults = withObject "Top Object from response." $ \o -> o .: "ParsedResults"

-- | Get the ParsedText field from every object in the ParsedResults array of
-- the response json.
parseParsedText :: Value -> Parser [T.Text]
parseParsedText = withArray "ParsedResults Array" $ \arr -> mapM parseText
    (V.toList arr)

-- | Parse the ParsedText field from the top object from the json response.
fullParseParsedText :: Value -> Parser [T.Text]
fullParseParsedText obj = parseParsedResults obj >>= parseParsedText

-- | From a succesful json parse modify the result to be able to print the
-- result with the newlines that appear in the response.
-- The reverse is to make the results correspond from top to bottom with the
-- page.
showStyleNewlines :: Result [T.Text] -> [T.Text]
showStyleNewlines (Success (x:_)) = reverse $ T.lines $ T.filter (/= '\r') x
showStyleNewlines (Error s) = [T.pack s]

-- | Uses ushow but adds newlines, and removes the double quotes in the output
-- string as a result of ushow.
ushowLn :: [T.Text] -> String
ushowLn xs = filter (/= '\"') $ dropWhile (== '\n') $ foldr step "" xs
  where
    step text soFar = soFar ++ ('\n' : ushow text)