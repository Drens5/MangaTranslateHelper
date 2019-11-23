{-# LANGUAGE DeriveGeneric     #-}
{-# LANGUAGE OverloadedStrings #-}

module RequestDetails
    ( defaultRequest
    ) where

import Control.Monad
import Control.Monad.IO.Class
import Data.Aeson
import Data.Text (Text)
import GHC.Generics
import Network.HTTP.Req
import System.IO (FilePath)
import Data.ByteString (ByteString)
import Data.ByteString.UTF8 (fromString)
import Data.Proxy
import Data.Monoid ((<>))

-- A nice update here would be to use the reader monad so that a user only need
-- to specify their API key in an external file.
defaultRequest :: FromJSON a => String -> Req (JsonResponse a)
defaultRequest path = req POST (https "api.ocr.space" /: "parse" /: "image")
    (ReqBodyUrlEnc apiParameters) jsonResponse apikeyHeader
  where
    apiParameters =
        "url" =: (path :: String) <>
        "language" =: ("jpn" :: String) <>
        "isOverlayRequired" =: ("False" :: String) <>
        "filetype" =: ("PNG" :: String) <>
        "scale" =: ("True" :: String) <>
        "OCREngine" =: ("1" :: String)
    apikeyHeader = header (fromString "apikey") (fromString "")