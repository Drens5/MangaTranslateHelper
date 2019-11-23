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

writeParsedTextToFile :: (FromJSON a, Show a) => FilePath -> JsonResponse a -> IO ()
writeParsedTextToFile file response = writeFile file $ ushow $
    responseBody response