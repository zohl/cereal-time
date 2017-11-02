{-# LANGUAGE RecordWildCards #-}
{-# LANGUAGE CPP #-}
{-# OPTIONS_GHC -fno-warn-orphans #-}

{-|
  Module:      Data.Time.LocalTime.Serialize
  Copyright:   (c) 2017 Al Zohali
  License:     BSD3
  Maintainer:  Al Zohali <zohl@fmap.me>
  Stability:   stable

  = Description
  'Serialize' instances for datatypes from 'Data.Time.LocalTime'.
-}
module Data.Time.LocalTime.Serialize where

import Data.Time.Calendar.Serialize ()
import Data.Time.LocalTime (TimeZone(..), TimeOfDay(..), LocalTime(..), ZonedTime(..))
import Data.Serialize (Serialize(..))

#if !MIN_VERSION_base(4,8,0)
import Control.Applicative ((<$>), (<*>))
#endif

-- | 'Serialize' instance for 'TimeZone'.
instance Serialize TimeZone where
  put TimeZone {..} = put timeZoneMinutes >> put timeZoneSummerOnly >> put timeZoneName
  get = TimeZone <$> get <*> get <*> get

-- | 'Serialize' instance for 'TimeOfDay'.
instance Serialize TimeOfDay where
  put TimeOfDay {..} = put todHour >> put todMin >> put (toRational todSec)
  get = TimeOfDay <$> get <*> get <*> (fromRational <$> get)

-- | 'Serialize' instance for 'LocalTime'.
instance Serialize LocalTime where
  put LocalTime {..} = put localDay >> put localTimeOfDay
  get = LocalTime <$> get <*> get

-- | 'Serialize' instance for 'ZonedTime'.
instance Serialize ZonedTime where
  put ZonedTime {..} = put zonedTimeToLocalTime >> put zonedTimeZone
  get = ZonedTime <$> get <*> get
