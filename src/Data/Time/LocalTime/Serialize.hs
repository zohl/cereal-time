{-# LANGUAGE RecordWildCards #-}
{-# OPTIONS_GHC -fno-warn-orphans #-}

module Data.Time.LocalTime.Serialize where

import Data.Time.Calendar.Serialize ()
import Data.Time.LocalTime (TimeZone(..), TimeOfDay(..), LocalTime(..), ZonedTime(..))
import Data.Serialize (Serialize(..))


instance Serialize TimeZone where
  put TimeZone {..} = put timeZoneMinutes >> put timeZoneSummerOnly >> put timeZoneName
  get = TimeZone <$> get <*> get <*> get

instance Serialize TimeOfDay where
  put TimeOfDay {..} = put todHour >> put todMin >> put (toRational todSec)
  get = TimeOfDay <$> get <*> get <*> (fromRational <$> get)

instance Serialize LocalTime where
  put LocalTime {..} = put localDay >> put localTimeOfDay
  get = LocalTime <$> get <*> get

instance Serialize ZonedTime where
  put ZonedTime {..} = put zonedTimeToLocalTime >> put zonedTimeZone
  get = ZonedTime <$> get <*> get
