module Main where

import RequestDetails
import Network.HTTP.Req
import Data.Aeson
import Text.Show.Unicode
import ResponseHandling
import System.IO (FilePath)
import Kanji.Dictionary

main :: IO ()
main = multiUrlRequests

-- https://i.imgur.com/nh7yhKz.png
-- https://i.imgur.com/LNSTgqy.png
-- "files/response.txt"

-- | Run all the requests specified in configuration/requestdata.txt.
multiUrlRequests :: IO ()
multiUrlRequests = loadRequestData >>= mapM_ singleUrlRequestData

-- | Run a single request with remote url.
singleUrlRequest :: String -> FilePath -> IO ()
singleUrlRequest url responseFilePath = getApiKey >>= (\apiKey -> runReq
    defaultHttpConfig (urlRequest url apiKey))
    >>= (\response -> writeParsedTextToFile responseFilePath
    (responseBody response :: Value)) -- This works, but if I use responseBody in writeParsedTextToFile this type signature can't be added

-- | Run a single request with remote url using singleUrlRequest.
singleUrlRequestData :: RemoteImage -> IO ()
singleUrlRequestData remoteImage = singleUrlRequest (url remoteImage)
    (savePath remoteImage)

-- | Makes a single url request with remote url but writes the full json response
-- to "response/response.txt"
singleUrlRequestRawResponse :: String -> IO ()
singleUrlRequestRawResponse url = getApiKey >>=
    (\apiKey -> runReq defaultHttpConfig (urlRequest url apiKey))
    >>= (\response -> writeJsonResponseToFile "response.txt"
    (responseBody response :: Value))