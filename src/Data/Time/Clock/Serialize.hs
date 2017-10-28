{-# LANGUAGE RecordWildCards #-}
{-# OPTIONS_GHC -fno-warn-orphans #-}

module Data.Time.Clock.Serialize where

import Data.Serialize (Serialize(..))
import Data.Time.Clock (UniversalTime(..), DiffTime, UTCTime(..), NominalDiffTime)
import Data.Time.Clock (diffTimeToPicoseconds, picosecondsToDiffTime)
import Data.Time.Calendar.Serialize ()


instance Serialize UniversalTime where
  put = put . getModJulianDate
  get = ModJulianDate <$> get

instance Serialize DiffTime where
  put = put . diffTimeToPicoseconds
  get = picosecondsToDiffTime <$> get

instance Serialize UTCTime where
  put UTCTime {..} = put utctDay >> put utctDayTime
  get = UTCTime <$> get <*> get

instance Serialize NominalDiffTime where
  put = put . toRational
  get = fromRational <$> get
