{-# LANGUAGE CPP #-}
{-# OPTIONS_GHC -fno-warn-orphans #-}

{-|
  Module:      Data.Time.Clock.TAI.Serialize
  Copyright:   (c) 2017 Al Zohali
  License:     BSD3
  Maintainer:  Al Zohali <zohl@fmap.me>
  Stability:   stable

  = Description
  'Serialize' instances for datatypes from 'Data.Time.Clock.TAI'.
-}
module Data.Time.Clock.TAI.Serialize where

import Data.Serialize (Serialize(..))
import Data.Time.Clock.Serialize()
import Data.Time.Clock.TAI (AbsoluteTime)
import Data.Time.Clock.TAI (addAbsoluteTime, diffAbsoluteTime, taiEpoch)

#if !MIN_VERSION_base(4,8,0)
import Control.Applicative ((<$>))
#endif

-- | 'Serialize' instance for 'AbsoluteTime'.
instance Serialize AbsoluteTime where
  put = put . flip diffAbsoluteTime taiEpoch
  get = (flip addAbsoluteTime taiEpoch) <$> get
