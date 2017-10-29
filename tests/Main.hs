{-# OPTIONS_GHC -fno-warn-orphans #-}

module Main where

import Data.Char (isAlpha)
import Data.Function (on)
import Data.Proxy (Proxy(..))
import Data.Serialize (Serialize(..), encode, decode)
import Data.Time.Calendar (Day(..))
import Data.Time.Calendar.Serialize ()
import Data.Time.Clock (UniversalTime(..), DiffTime, UTCTime(..), NominalDiffTime)
import Data.Time.Clock (picosecondsToDiffTime)
import Data.Time.Clock.Serialize()
import Data.Time.Clock.TAI (AbsoluteTime)
import Data.Time.Clock.TAI (addAbsoluteTime, taiEpoch)
import Data.Time.Clock.TAI.Serialize ()
import Data.Time.LocalTime (TimeZone(..), TimeOfDay(..), LocalTime(..), ZonedTime(..))
import Data.Time.LocalTime.Serialize ()
import Data.Typeable (Typeable, typeRep)
import Test.Hspec (Spec, shouldBe, describe, hspec)
import Test.Hspec.QuickCheck (prop)
import Test.QuickCheck (Arbitrary(..), suchThat, resize, listOf, choose)


main :: IO ()
main = hspec spec

spec :: Spec
spec = do
  describe "Serialization roundtrip" serializationRoundTripSpec

serializationRoundTripSpec :: Spec
serializationRoundTripSpec = do
  propRoundTrip (Proxy :: Proxy Day)
  propRoundTrip (Proxy :: Proxy UniversalTime)
  propRoundTrip (Proxy :: Proxy DiffTime)
  propRoundTrip (Proxy :: Proxy UTCTime)
  propRoundTrip (Proxy :: Proxy AbsoluteTime)
  propRoundTrip (Proxy :: Proxy TimeZone)
  propRoundTrip (Proxy :: Proxy TimeOfDay)
  propRoundTrip (Proxy :: Proxy LocalTime)
  propRoundTrip (Proxy :: Proxy ZonedTime)

mkTestName
  :: (Serialize a, Arbitrary a, Show a, Eq a, Typeable a)
  => Proxy a
  -> String
mkTestName a = "(" ++ (show . typeRep $ a) ++ ")"

propRoundTrip
  :: (Serialize a, Arbitrary a, Show a, Eq a, Typeable a)
  => Proxy a
  -> Spec
propRoundTrip a = prop (mkTestName a) $
  \x -> x `shouldBe` (roundTrip a x)

roundTrip :: (Serialize a) => Proxy a -> a -> a
roundTrip _ = either error id . decode . encode


instance Arbitrary Day where
  arbitrary = ModifiedJulianDay <$> arbitrary

instance Arbitrary UniversalTime where
  arbitrary = ModJulianDate <$> arbitrary

instance Arbitrary DiffTime where
  arbitrary = picosecondsToDiffTime <$> arbitrary

instance Arbitrary UTCTime where
  arbitrary = UTCTime <$> arbitrary <*> arbitrary

instance Arbitrary NominalDiffTime where
  arbitrary = fromRational <$> arbitrary

instance Arbitrary AbsoluteTime where
  arbitrary = (flip addAbsoluteTime taiEpoch) <$> arbitrary

instance Arbitrary TimeZone where
  arbitrary = TimeZone
    <$> arbitrary
    <*> arbitrary
    <*> (resize 4 $ listOf (arbitrary `suchThat` isAlpha))

instance Arbitrary TimeOfDay where
  arbitrary = TimeOfDay
    <$> (choose (0, 23))
    <*> (choose (0, 59))
    <*> ((fromRational <$> arbitrary) `suchThat` (\s -> (s >= (fromInteger 0)) && (s < (fromInteger 61))))

instance Arbitrary LocalTime where
  arbitrary = LocalTime <$> arbitrary <*> arbitrary

-- Per-component equality test (we do not expect serialization to change time zone).
instance Eq ZonedTime where
  (==) = curry $ flip all components . flip ($) where
    test f = uncurry ((==) `on` f)
    components = [
        test zonedTimeToLocalTime
      , test zonedTimeZone
      ]

instance Arbitrary ZonedTime where
  arbitrary = ZonedTime <$> arbitrary <*> arbitrary

