{-# OPTIONS_GHC -fno-warn-orphans #-}

module Data.Time.Clock.TAI.Serialize where

import Data.Serialize (Serialize(..))
import Data.Time.Clock.Serialize()
import Data.Time.Clock.TAI (AbsoluteTime)
import Data.Time.Clock.TAI (addAbsoluteTime, diffAbsoluteTime, taiEpoch)


instance Serialize AbsoluteTime where
  put = put . flip diffAbsoluteTime taiEpoch
  get = (flip addAbsoluteTime taiEpoch) <$> get
