{-# LANGUAGE RecordWildCards #-}
{-# OPTIONS_GHC -fno-warn-orphans #-}

module Data.Time.Format.Serialize where

import Data.Time.Format (TimeLocale(..))
import Data.Time.LocalTime.Serialize ()
import Data.Serialize (Serialize(..))

instance Serialize TimeLocale where
  put TimeLocale {..} = do
    put wDays
    put months
    put amPm
    put dateTimeFmt
    put dateFmt
    put timeFmt
    put time12Fmt
    put knownTimeZones
  get = TimeLocale <$> get <*> get <*> get <*> get <*> get <*> get <*> get <*> get
