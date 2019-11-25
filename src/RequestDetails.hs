{-# LANGUAGE OverloadedStrings #-}

module RequestDetails
    ( urlRequest
    , getApiKey
    ) where

import Data.Aeson
import Network.HTTP.Req
import System.IO
import Data.ByteString.UTF8 (fromString)
import Data.Monoid ((<>))

type ApiKey = String

-- A nice update here would be to use the reader monad so that a user only need
-- to specify their API key in an external file.
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
getApiKey = (head . words) <$> readFile "files/apikey.txt"