{-# OPTIONS_GHC -fno-warn-orphans #-}
{-# LANGUAGE CPP #-}

{-|
  Module:      Data.Time.Calendar.Serialize
  Copyright:   (c) 2017 Al Zohali
  License:     BSD3
  Maintainer:  Al Zohali <zohl@fmap.me>
  Stability:   stable

  = Description
  'Serialize' instances for datatypes from 'Data.Time.Calendar'.
-}
module Data.Time.Calendar.Serialize where

import Data.Serialize (Serialize(..))
import Data.Time.Calendar (Day(..))

#if !MIN_VERSION_base(4,8,0)
import Control.Applicative ((<$>))
#endif

-- | 'Serialize' instance for 'Day'.
instance Serialize Day where
  put = put . toModifiedJulianDay
  get = ModifiedJulianDay <$> get
