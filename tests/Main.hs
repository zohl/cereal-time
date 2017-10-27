{-# OPTIONS_GHC -fno-warn-orphans #-}

module Main where

import Data.Proxy (Proxy(..))
import Data.Serialize (Serialize(..), encode, decode)
import Data.Time.Calendar (Day(..))
import Data.Time.Calendar.Serialize ()
import Data.Typeable (Typeable, typeRep)
import Test.Hspec (Spec, shouldBe, describe, hspec)
import Test.Hspec.QuickCheck (prop)
import Test.QuickCheck (Arbitrary(..))


main :: IO ()
main = hspec spec

spec :: Spec
spec = do
  describe "Serialization roundtrip" serializationRoundTripSpec

serializationRoundTripSpec :: Spec
serializationRoundTripSpec = do
  propRoundTrip (Proxy :: Proxy Day)


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
