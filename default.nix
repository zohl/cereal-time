{ mkDerivation, base, cereal, hspec, QuickCheck, stdenv, time }:
mkDerivation {
  pname = "cereal-time";
  version = "0.1.0.0";
  src = ./.;
  libraryHaskellDepends = [ base cereal time ];
  testHaskellDepends = [ base cereal hspec QuickCheck time ];
  description = "Serialize instances for types from `time` package";
  license = stdenv.lib.licenses.bsd3;
}
