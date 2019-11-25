{-# LANGUAGE OverloadedStrings #-}

module RequestDetails
    ( urlRequest
    , getApiKey
    , loadRequestData
    , RemoteImage (url, savePath)
    ) where

import Data.Aeson
import Network.HTTP.Req
import System.IO
import Data.ByteString.UTF8 (fromString)
import Data.Monoid ((<>))

type ApiKey = String

data RemoteImage = RemoteImage
    { savePath :: FilePath -- Will be relative to response folder, see ResponseHandling write functions.
    , url :: String
    }

loadRequestData :: IO [RemoteImage]
loadRequestData = parseRequestData <$> readFile "configuration/requestdata.txt"

-- | String has to be in the following format: have lines in the following form
-- "savePath" (any amount of whitespace) "remoteUrl".
parseRequestData :: String -> [RemoteImage]
parseRequestData requestData = foldr (step . words) [] (lines requestData)
  where
    step (path : remoteUrl : _) acc = RemoteImage path remoteUrl : acc

urlRequest :: FromJSON a => String -> ApiKey -> Req (JsonResponse a)
urlRequest remoteUrl apiKey = req POST (https "api.ocr.space" /: "parse" /: "image")
    (ReqBodyUrlEnc apiParameters) jsonResponse apikeyHeader
  where
    apiParameters =
        "url" =: (remoteUrl :: String) <>
        "language" =: ("jpn" :: String) <>
        "isOverlayRequired" =: ("False" :: String) <>
        "filetype" =: ("PNG" :: String) <>
        "scale" =: ("True" :: String) <>
        "OCREngine" =: ("1" :: String)
    apikeyHeader = header (fromString "apikey") (fromString apiKey)

-- | Parses the apiKey from files/apikey.txt. (UNSAFE)
-- The apiKey has to be the first non-whitespace string in the file.
getApiKey :: IO ApiKey
getApiKey = (head . words) <$> readFile "configuration/apikey.txt"