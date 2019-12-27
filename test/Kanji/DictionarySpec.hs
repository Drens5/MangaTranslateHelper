{-# LANGUAGE OverloadedStrings #-}
module Kanji.DictionarySpec (spec) where

import Test.Hspec
import Kanji.Dictionary
import Control.Monad.Except
import Data.Either
import qualified Data.Text.Lazy as L
import qualified Data.Text.Lazy.IO as LIO

spec :: Spec
spec = do
  kanjiEntrySpec

readDic :: IO L.Text
readDic = LIO.readFile "dic/kanjidic2.xml"

kanjiEntrySpec :: Spec
kanjiEntrySpec = before (LIO.readFile "dic/kanjidic2.xml") $ do
  describe "kanjiEntry" $ do
    it "has contents that start at the opening character tag" $ \dic -> do
      (head . fromRight [L.pack "not Right"] . runExcept) (kanjiEntry "愡"
        dic) `shouldBe` "<character>"

    it "contents end with closing reading_meaning tag" $ \dic -> do
      (last . fromRight [L.pack "not Right"] . runExcept) (kanjiEntry "愡"
        dic) `shouldBe` "</reading_meaning>"

    context "when the entry is not in KANJIDIC2" $ do
      it "throws the right exception from Except monad" $ \dic -> do
        runExcept (kanjiEntry "䢈" dic) `shouldBe`
          Left "Kanji `䢈' not in KANJIDIC2."