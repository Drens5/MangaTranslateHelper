{-# LANGUAGE OverloadedStrings #-}
module Kanji.Dictionary where

import System.IO
import Control.Monad.Except
import Data.List
import qualified Data.Text.Lazy as L
import qualified Data.Text.Lazy.IO as LIO

-- | Lookup kanji using KANJIDIC2, located in ../../dic.

data KanjiInfo = KanjiInfo
    { kanji       ::  L.Text
    , readingsOn  :: [L.Text]
    , readingsKun :: [L.Text]
    , meanings    :: [L.Text]
    }

-- | The KanjiInfo of the kanji specified.
getKanjiInfo :: L.Text -> ExceptT L.Text IO KanjiInfo
getKanjiInfo kanji = undefined -- LIO.readFile "dic/kanjidic2.xml"

-- | The info between the character tags of the kanji if it is found in the dic.
-- The dic is assumed to be KANJIDIC2.
-- Throws a string exception if the kanji is not present in KANJIDIC2.
kanjiEntry :: L.Text -> L.Text -> Except L.Text [L.Text]
kanjiEntry kanji dic = case dropWhile isNotKanjiComment (L.lines dic) of
        []     -> throwError $ "Kanji `" `L.append` kanji `L.append` "' not in KANJIDIC2."
        (x:xs) -> return $ takeWhile (/= "</character>") xs
  where
    isNotKanjiComment line = not $ ("<!-- Entry for Kanji: " `L.append` kanji)
        `L.isPrefixOf` line