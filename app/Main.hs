module Main where

import RequestDetails
import Network.HTTP.Req
import Data.Aeson
import Text.Show.Unicode
import ResponseHandling

main :: IO ()
main = runReq defaultHttpConfig (defaultRequest "https://i.imgur.com/LNSTgqy.png") -- After this we are back in IO monad.
    >>= (\response -> writeParsedTextToFile "files/response.txt"
    (responseBody response :: Value)) -- This works, but if I use responseBody in writeParsedTextToFile this type signature can't be added