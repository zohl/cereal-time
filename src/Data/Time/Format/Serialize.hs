{-# LANGUAGE RecordWildCards #-}
{-# LANGUAGE CPP #-}
{-# OPTIONS_GHC -fno-warn-orphans #-}

{-|
  Module:      Data.Time.Format.Serialize
  Copyright:   (c) 2017 Al Zohali
  License:     BSD3
  Maintainer:  Al Zohali <zohl@fmap.me>
  Stability:   stable

  = Description
  'Serialize' instances for datatypes from 'Data.Time.Format'.
-}
module Data.Time.Format.Serialize where

import Data.Time.Format (TimeLocale(..))
import Data.Time.LocalTime.Serialize ()
import Data.Serialize (Serialize(..))

#if !MIN_VERSION_base(4,8,0)
import Control.Applicative ((<$>), (<*>))
#endif

-- | 'Serialize' instance for 'TimeLocale'.
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
