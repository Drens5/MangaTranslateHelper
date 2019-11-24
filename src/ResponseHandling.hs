{-# LANGUAGE OverloadedStrings #-}
module ResponseHandling
    ( writeParsedTextToFile
    ) where

import Control.Monad
import Control.Monad.IO.Class
import Data.Aeson
import Data.Text (Text)
import GHC.Generics
import Network.HTTP.Req
import System.IO
import Data.ByteString (ByteString)
import Data.ByteString.UTF8 (fromString)
import Data.Proxy
import Data.Monoid ((<>))
import Text.Show.Unicode
import qualified Data.Vector as V
import Data.Aeson.Types

writeParsedTextToFile :: FilePath -> Value -> IO ()
writeParsedTextToFile file response = writeFile file $ ushow $
    parse fullParseParsedText response

-- | The array it's in is an array of objects and this is afield in that innner
-- object. Get the parsedText field out of the object.
parseText :: Value -> Parser Text
parseText = withObject "Object within ParsedResults" $ \o -> o .: "ParsedText"

-- Get the ParsedResults field (which is array) from the json response.
parseParsedResults :: Value -> Parser Value -- Soo arrays have type Value.
parseParsedResults = withObject "Top Object from response." $ \o -> o .: "ParsedResults"

-- | Get the ParsedText field from every object in the ParsedResults array of
-- the response json.
parseParsedText :: Value -> Parser [Text]
parseParsedText = withArray "ParsedResults Array" $ \arr -> mapM parseText
    (V.toList arr)

-- | Parse the ParsedText field from the top object from the json response.
fullParseParsedText :: Value -> Parser [Text]
fullParseParsedText obj = parseParsedResults obj >>= parseParsedText