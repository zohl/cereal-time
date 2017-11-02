{-# LANGUAGE RecordWildCards #-}
{-# LANGUAGE CPP #-}
{-# OPTIONS_GHC -fno-warn-orphans #-}

{-|
  Module:      Data.Time.Clock.Serialize
  Copyright:   (c) 2017 Al Zohali
  License:     BSD3
  Maintainer:  Al Zohali <zohl@fmap.me>
  Stability:   stable

  = Description
  'Serialize' instances for datatypes from 'Data.Time.Clock'.
-}
module Data.Time.Clock.Serialize where

import Data.Serialize (Serialize(..))
import Data.Time.Clock (UniversalTime(..), DiffTime, UTCTime(..), NominalDiffTime)
import Data.Time.Clock (diffTimeToPicoseconds, picosecondsToDiffTime)
import Data.Time.Calendar.Serialize ()

#if !MIN_VERSION_base(4,8,0)
import Control.Applicative ((<$>), (<*>))
#endif

-- | 'Serialize' instance for 'UniversalTime'.
instance Serialize UniversalTime where
  put = put . getModJulianDate
  get = ModJulianDate <$> get

-- | 'Serialize' instance for 'DiffTime'.
instance Serialize DiffTime where
  put = put . diffTimeToPicoseconds
  get = picosecondsToDiffTime <$> get

-- | 'Serialize' instance for 'UTCTime'.
instance Serialize UTCTime where
  put UTCTime {..} = put utctDay >> put utctDayTime
  get = UTCTime <$> get <*> get

-- | 'Serialize' instance for 'NominalDiffTime'.
instance Serialize NominalDiffTime where
  put = put . toRational
  get = fromRational <$> get
