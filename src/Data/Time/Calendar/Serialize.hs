{-# OPTIONS_GHC -fno-warn-orphans #-}

module Data.Time.Calendar.Serialize where

import Data.Serialize (Serialize(..))
import Data.Time.Calendar (Day(..))

instance Serialize Day where
  put = put . toModifiedJulianDay
  get = ModifiedJulianDay <$> get
