{-# LANGUAGE OverloadedStrings #-}
module Kanji.Dictionary where

import System.IO
import qualified Data.Text as T

-- | Lookup kanji using KANJIDIC2, located in ../../dic.

data KanjiInfo = KanjiInfo
    { kanji       ::  T.Text
    , readingsOn  :: [T.Text]
    , readingsKun :: [T.Text]
    , meanings    :: [T.Text]
    }

-- | The KanjiInfo of the kanji specified.
getKanjiInfo :: T.Text -> IO KanjiInfo
getKanjiInfo kanji = undefined