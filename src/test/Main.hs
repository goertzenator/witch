{-# LANGUAGE FlexibleInstances #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE TypeApplications #-}

import qualified Control.Exception as Exception
import qualified Control.Monad as Monad
import qualified Data.Complex as Complex
import qualified Data.Either as Either
import qualified Data.Fixed as Fixed
import qualified Data.Int as Int
import qualified Data.List.NonEmpty as NonEmpty
import qualified Data.Ratio as Ratio
import qualified Data.Word as Word
import qualified Numeric.Natural as Natural
import qualified Test.Hspec as Hspec
import qualified Witch as Witch

main :: IO ()
main = Hspec.hspec . Hspec.describe "Witch" $ do

  Hspec.describe "Cast" $ do

    Hspec.describe "cast" $ do
      test $ Witch.cast (1 :: Int.Int8) `Hspec.shouldBe` (1 :: Int.Int16)

  Hspec.describe "TryCast" $ do

    Hspec.describe "tryCast" $ do
      test $ Witch.tryCast (1 :: Int.Int16) `Hspec.shouldBe` Right (1 :: Int.Int8)
      test $ Witch.tryCast 128 `Hspec.shouldBe` Left (Witch.TryCastException @Int.Int16 @Int.Int8 128)

  Hspec.describe "Utility" $ do

    Hspec.describe "as" $ do
      test $ Witch.as @Int.Int8 1 `Hspec.shouldBe` 1

    Hspec.describe "from" $ do
      test $ Witch.from @Int.Int8 1 `Hspec.shouldBe` (1 :: Int.Int16)

    Hspec.describe "into" $ do
      test $ Witch.into @Int.Int16 (1 :: Int.Int8) `Hspec.shouldBe` 1

    Hspec.describe "over" $ do
      test $ Witch.over @String (<> "!") (Name "Kiki") `Hspec.shouldBe` Name "Kiki!"

    Hspec.describe "via" $ do
      test $ Witch.via @Int.Int16 (1 :: Int.Int8) `Hspec.shouldBe` (1 :: Int.Int32)

    Hspec.describe "tryFrom" $ do
      test $ Witch.tryFrom @Int.Int16 1 `Hspec.shouldBe` Right (1 :: Int.Int8)

    Hspec.describe "tryInto" $ do
      test $ Witch.tryInto @Int.Int8 (1 :: Int.Int16) `Hspec.shouldBe` Right 1

    Hspec.describe "unsafeCast" $ do
      test $ Witch.unsafeCast (1 :: Int.Int16) `Hspec.shouldBe` (1 :: Int.Int8)
      test $ Exception.evaluate (Witch.unsafeCast @Int.Int16 @Int.Int8 128) `Hspec.shouldThrow` (== Witch.TryCastException @Int.Int16 @Int.Int8 128)

    Hspec.describe "unsafeFrom" $ do
      test $ Witch.unsafeFrom @Int.Int16 1 `Hspec.shouldBe` (1 :: Int.Int8)

    Hspec.describe "unsafeInto" $ do
      test $ Witch.unsafeInto @Int.Int8 (1 :: Int.Int16) `Hspec.shouldBe` 1

  Hspec.describe "Lift" $ do

    Hspec.describe "liftedCast" $ do
      test $ ($$(Witch.liftedCast (1 :: Int.Int16)) :: Int.Int8) `Hspec.shouldBe` 1

    Hspec.describe "liftedFrom" $ do
      test $ ($$(Witch.liftedFrom @Int.Int16 1) :: Int.Int8) `Hspec.shouldBe` 1

    Hspec.describe "liftedInto" $ do
      test $ ($$(Witch.liftedInto @Int.Int8 (1 :: Int.Int16))) `Hspec.shouldBe` 1

  Hspec.describe "Instances" $ do

    -- Int8

    Hspec.describe "Cast Int8 Int16" $ do
      let f = Witch.cast @Int.Int8 @Int.Int16
      test $ f 0 `Hspec.shouldBe` 0
      test $ f 127 `Hspec.shouldBe` 127
      test $ f (-128) `Hspec.shouldBe` (-128)

    Hspec.describe "Cast Int8 Int32" $ do
      let f = Witch.cast @Int.Int8 @Int.Int32
      test $ f 0 `Hspec.shouldBe` 0
      test $ f 127 `Hspec.shouldBe` 127
      test $ f (-128) `Hspec.shouldBe` (-128)

    Hspec.describe "Cast Int8 Int64" $ do
      let f = Witch.cast @Int.Int8 @Int.Int64
      test $ f 0 `Hspec.shouldBe` 0
      test $ f 127 `Hspec.shouldBe` 127
      test $ f (-128) `Hspec.shouldBe` (-128)

    Hspec.describe "Cast Int8 Int" $ do
      let f = Witch.cast @Int.Int8 @Int
      test $ f 0 `Hspec.shouldBe` 0
      test $ f 127 `Hspec.shouldBe` 127
      test $ f (-128) `Hspec.shouldBe` (-128)

    Hspec.describe "Cast Int8 Integer" $ do
      let f = Witch.cast @Int.Int8 @Integer
      test $ f 0 `Hspec.shouldBe` 0
      test $ f 127 `Hspec.shouldBe` 127
      test $ f (-128) `Hspec.shouldBe` (-128)

    Hspec.describe "TryCast Int8 Word8" $ do
      let f = Witch.tryCast @Int.Int8 @Word.Word8
      test $ f 0 `Hspec.shouldBe` Right 0
      test $ f 127 `Hspec.shouldBe` Right 127
      test $ f (-1) `Hspec.shouldSatisfy` Either.isLeft

    Hspec.describe "TryCast Int8 Word16" $ do
      let f = Witch.tryCast @Int.Int8 @Word.Word16
      test $ f 0 `Hspec.shouldBe` Right 0
      test $ f 127 `Hspec.shouldBe` Right 127
      test $ f (-1) `Hspec.shouldSatisfy` Either.isLeft

    Hspec.describe "TryCast Int8 Word32" $ do
      let f = Witch.tryCast @Int.Int8 @Word.Word32
      test $ f 0 `Hspec.shouldBe` Right 0
      test $ f 127 `Hspec.shouldBe` Right 127
      test $ f (-1) `Hspec.shouldSatisfy` Either.isLeft

    Hspec.describe "TryCast Int8 Word64" $ do
      let f = Witch.tryCast @Int.Int8 @Word.Word64
      test $ f 0 `Hspec.shouldBe` Right 0
      test $ f 127 `Hspec.shouldBe` Right 127
      test $ f (-1) `Hspec.shouldSatisfy` Either.isLeft

    Hspec.describe "TryCast Int8 Word" $ do
      let f = Witch.tryCast @Int.Int8 @Word
      test $ f 0 `Hspec.shouldBe` Right 0
      test $ f 127 `Hspec.shouldBe` Right 127
      test $ f (-1) `Hspec.shouldSatisfy` Either.isLeft

    Hspec.describe "TryCast Int8 Natural" $ do
      let f = Witch.tryCast @Int.Int8 @Natural.Natural
      test $ f 0 `Hspec.shouldBe` Right 0
      test $ f 127 `Hspec.shouldBe` Right 127
      test $ f (-1) `Hspec.shouldSatisfy` Either.isLeft

    Hspec.describe "Cast Int8 Float" $ do
      let f = Witch.cast @Int.Int8 @Float
      test $ f 0 `Hspec.shouldBe` 0
      test $ f 127 `Hspec.shouldBe` 127
      test $ f (-128) `Hspec.shouldBe` (-128)

    Hspec.describe "Cast Int8 Double" $ do
      let f = Witch.cast @Int.Int8 @Double
      test $ f 0 `Hspec.shouldBe` 0
      test $ f 127 `Hspec.shouldBe` 127
      test $ f (-128) `Hspec.shouldBe` (-128)

    -- Int16

    Hspec.describe "TryCast Int16 Int8" $ do
      let f = Witch.tryCast @Int.Int16 @Int.Int8
      test $ f 0 `Hspec.shouldBe` Right 0
      test $ f 127 `Hspec.shouldBe` Right 127
      test $ f 128 `Hspec.shouldSatisfy` Either.isLeft
      test $ f (-128) `Hspec.shouldBe` Right (-128)
      test $ f (-129) `Hspec.shouldSatisfy` Either.isLeft

    Hspec.describe "Cast Int16 Int32" $ do
      let f = Witch.cast @Int.Int16 @Int.Int32
      test $ f 0 `Hspec.shouldBe` 0
      test $ f 32767 `Hspec.shouldBe` 32767
      test $ f (-32768) `Hspec.shouldBe` (-32768)

    Hspec.describe "Cast Int16 Int64" $ do
      let f = Witch.cast @Int.Int16 @Int.Int64
      test $ f 0 `Hspec.shouldBe` 0
      test $ f 32767 `Hspec.shouldBe` 32767
      test $ f (-32768) `Hspec.shouldBe` (-32768)

    Hspec.describe "Cast Int16 Int" $ do
      let f = Witch.cast @Int.Int16 @Int
      test $ f 0 `Hspec.shouldBe` 0
      test $ f 32767 `Hspec.shouldBe` 32767
      test $ f (-32768) `Hspec.shouldBe` (-32768)

    Hspec.describe "Cast Int16 Integer" $ do
      let f = Witch.cast @Int.Int16 @Integer
      test $ f 0 `Hspec.shouldBe` 0
      test $ f 32767 `Hspec.shouldBe` 32767
      test $ f (-32768) `Hspec.shouldBe` (-32768)

    Hspec.describe "TryCast Int16 Word8" $ do
      let f = Witch.tryCast @Int.Int16 @Word.Word8
      test $ f 0 `Hspec.shouldBe` Right 0
      test $ f 255 `Hspec.shouldBe` Right 255
      test $ f 256 `Hspec.shouldSatisfy` Either.isLeft
      test $ f (-1) `Hspec.shouldSatisfy` Either.isLeft

    Hspec.describe "TryCast Int16 Word16" $ do
      let f = Witch.tryCast @Int.Int16 @Word.Word16
      test $ f 0 `Hspec.shouldBe` Right 0
      test $ f 127 `Hspec.shouldBe` Right 127
      test $ f (-1) `Hspec.shouldSatisfy` Either.isLeft

    Hspec.describe "TryCast Int16 Word32" $ do
      let f = Witch.tryCast @Int.Int16 @Word.Word32
      test $ f 0 `Hspec.shouldBe` Right 0
      test $ f 32767 `Hspec.shouldBe` Right 32767
      test $ f (-1) `Hspec.shouldSatisfy` Either.isLeft

    Hspec.describe "TryCast Int16 Word64" $ do
      let f = Witch.tryCast @Int.Int16 @Word.Word64
      test $ f 0 `Hspec.shouldBe` Right 0
      test $ f 32767 `Hspec.shouldBe` Right 32767
      test $ f (-1) `Hspec.shouldSatisfy` Either.isLeft

    Hspec.describe "TryCast Int16 Word" $ do
      let f = Witch.tryCast @Int.Int16 @Word
      test $ f 0 `Hspec.shouldBe` Right 0
      test $ f 32767 `Hspec.shouldBe` Right 32767
      test $ f (-1) `Hspec.shouldSatisfy` Either.isLeft

    Hspec.describe "TryCast Int16 Natural" $ do
      let f = Witch.tryCast @Int.Int16 @Natural.Natural
      test $ f 0 `Hspec.shouldBe` Right 0
      test $ f 32767 `Hspec.shouldBe` Right 32767
      test $ f (-1) `Hspec.shouldSatisfy` Either.isLeft

    Hspec.describe "Cast Int16 Float" $ do
      let f = Witch.cast @Int.Int16 @Float
      test $ f 0 `Hspec.shouldBe` 0
      test $ f 32767 `Hspec.shouldBe` 32767
      test $ f (-32768) `Hspec.shouldBe` (-32768)

    Hspec.describe "Cast Int16 Double" $ do
      let f = Witch.cast @Int.Int16 @Double
      test $ f 0 `Hspec.shouldBe` 0
      test $ f 32767 `Hspec.shouldBe` 32767
      test $ f (-32768) `Hspec.shouldBe` (-32768)

    -- Int32

    Hspec.describe "TryCast Int32 Int8" $ do
      let f = Witch.tryCast @Int.Int32 @Int.Int8
      test $ f 0 `Hspec.shouldBe` Right 0
      test $ f 127 `Hspec.shouldBe` Right 127
      test $ f 128 `Hspec.shouldSatisfy` Either.isLeft
      test $ f (-128) `Hspec.shouldBe` Right (-128)
      test $ f (-129) `Hspec.shouldSatisfy` Either.isLeft

    Hspec.describe "TryCast Int32 Int16" $ do
      let f = Witch.tryCast @Int.Int32 @Int.Int16
      test $ f 0 `Hspec.shouldBe` Right 0
      test $ f 32767 `Hspec.shouldBe` Right 32767
      test $ f 32768 `Hspec.shouldSatisfy` Either.isLeft
      test $ f (-32768) `Hspec.shouldBe` Right (-32768)
      test $ f (-32769) `Hspec.shouldSatisfy` Either.isLeft

    Hspec.describe "Cast Int32 Int64" $ do
      let f = Witch.cast @Int.Int32 @Int.Int64
      test $ f 0 `Hspec.shouldBe` 0
      test $ f 2147483647 `Hspec.shouldBe` 2147483647
      test $ f (-2147483648) `Hspec.shouldBe` (-2147483648)

    Hspec.describe "TryCast Int32 Int" $ do
      Monad.when (toInteger (maxBound :: Int) < 2147483647) untested
      let f = Witch.tryCast @Int.Int32 @Int
      test $ f 0 `Hspec.shouldBe` Right 0
      test $ f 2147483647 `Hspec.shouldBe` Right 2147483647
      test $ f (-2147483648) `Hspec.shouldBe` Right (-2147483648)

    Hspec.describe "Cast Int32 Integer" $ do
      let f = Witch.cast @Int.Int32 @Integer
      test $ f 0 `Hspec.shouldBe` 0
      test $ f 2147483647 `Hspec.shouldBe` 2147483647
      test $ f (-2147483648) `Hspec.shouldBe` (-2147483648)

    Hspec.describe "TryCast Int32 Word8" $ do
      let f = Witch.tryCast @Int.Int32 @Word.Word8
      test $ f 0 `Hspec.shouldBe` Right 0
      test $ f 255 `Hspec.shouldBe` Right 255
      test $ f 256 `Hspec.shouldSatisfy` Either.isLeft
      test $ f (-1) `Hspec.shouldSatisfy` Either.isLeft

    Hspec.describe "TryCast Int32 Word16" $ do
      let f = Witch.tryCast @Int.Int32 @Word.Word16
      test $ f 0 `Hspec.shouldBe` Right 0
      test $ f 65535 `Hspec.shouldBe` Right 65535
      test $ f 65536 `Hspec.shouldSatisfy` Either.isLeft
      test $ f (-1) `Hspec.shouldSatisfy` Either.isLeft

    Hspec.describe "TryCast Int32 Word32" $ do
      let f = Witch.tryCast @Int.Int32 @Word.Word32
      test $ f 0 `Hspec.shouldBe` Right 0
      test $ f 2147483647 `Hspec.shouldBe` Right 2147483647
      test $ f (-1) `Hspec.shouldSatisfy` Either.isLeft

    Hspec.describe "TryCast Int32 Word64" $ do
      let f = Witch.tryCast @Int.Int32 @Word.Word64
      test $ f 0 `Hspec.shouldBe` Right 0
      test $ f 2147483647 `Hspec.shouldBe` Right 2147483647
      test $ f (-1) `Hspec.shouldSatisfy` Either.isLeft

    Hspec.describe "TryCast Int32 Word" $ do
      Monad.when (toInteger (maxBound :: Word) < 2147483647) untested
      let f = Witch.tryCast @Int.Int32 @Word
      test $ f 0 `Hspec.shouldBe` Right 0
      test $ f 2147483647 `Hspec.shouldBe` Right 2147483647
      test $ f (-1) `Hspec.shouldSatisfy` Either.isLeft

    Hspec.describe "TryCast Int32 Natural" $ do
      let f = Witch.tryCast @Int.Int32 @Natural.Natural
      test $ f 0 `Hspec.shouldBe` Right 0
      test $ f 2147483647 `Hspec.shouldBe` Right 2147483647
      test $ f (-1) `Hspec.shouldSatisfy` Either.isLeft

    Hspec.describe "TryCast Int32 Float" $ do
      let f = Witch.tryCast @Int.Int32 @Float
      test $ f 0 `Hspec.shouldBe` Right 0
      test $ f 16777215 `Hspec.shouldBe` Right 16777215
      test $ f 16777216 `Hspec.shouldSatisfy` Either.isLeft
      test $ f (-16777215) `Hspec.shouldBe` Right (-16777215)
      test $ f (-16777216) `Hspec.shouldSatisfy` Either.isLeft

    Hspec.describe "Cast Int32 Double" $ do
      let f = Witch.cast @Int.Int32 @Double
      test $ f 0 `Hspec.shouldBe` 0
      test $ f 2147483647 `Hspec.shouldBe` 2147483647
      test $ f (-2147483648) `Hspec.shouldBe` (-2147483648)

    -- Int64

    Hspec.describe "TryCast Int64 Int8" $ do
      let f = Witch.tryCast @Int.Int64 @Int.Int8
      test $ f 0 `Hspec.shouldBe` Right 0
      test $ f 127 `Hspec.shouldBe` Right 127
      test $ f 128 `Hspec.shouldSatisfy` Either.isLeft
      test $ f (-128) `Hspec.shouldBe` Right (-128)
      test $ f (-129) `Hspec.shouldSatisfy` Either.isLeft

    Hspec.describe "TryCast Int64 Int16" $ do
      let f = Witch.tryCast @Int.Int64 @Int.Int16
      test $ f 0 `Hspec.shouldBe` Right 0
      test $ f 32767 `Hspec.shouldBe` Right 32767
      test $ f 32768 `Hspec.shouldSatisfy` Either.isLeft
      test $ f (-32768) `Hspec.shouldBe` Right (-32768)
      test $ f (-32769) `Hspec.shouldSatisfy` Either.isLeft

    Hspec.describe "TryCast Int64 Int32" $ do
      let f = Witch.tryCast @Int.Int64 @Int.Int32
      test $ f 0 `Hspec.shouldBe` Right 0
      test $ f 2147483647 `Hspec.shouldBe` Right 2147483647
      test $ f 2147483648 `Hspec.shouldSatisfy` Either.isLeft
      test $ f (-2147483648) `Hspec.shouldBe` Right (-2147483648)
      test $ f (-2147483649) `Hspec.shouldSatisfy` Either.isLeft

    Hspec.describe "TryCast Int64 Int" $ do
      Monad.when (toInteger (maxBound :: Int) < 9223372036854775807) untested
      let f = Witch.tryCast @Int.Int64 @Int
      test $ f 0 `Hspec.shouldBe` Right 0
      test $ f 9223372036854775807 `Hspec.shouldBe` Right 9223372036854775807
      test $ f (-9223372036854775808) `Hspec.shouldBe` Right (-9223372036854775808)

    Hspec.describe "Cast Int64 Integer" $ do
      let f = Witch.cast @Int.Int64 @Integer
      test $ f 0 `Hspec.shouldBe` 0
      test $ f 9223372036854775807 `Hspec.shouldBe` 9223372036854775807
      test $ f (-9223372036854775808) `Hspec.shouldBe` (-9223372036854775808)

    Hspec.describe "TryCast Int64 Word8" $ do
      let f = Witch.tryCast @Int.Int64 @Word.Word8
      test $ f 0 `Hspec.shouldBe` Right 0
      test $ f 255 `Hspec.shouldBe` Right 255
      test $ f 256 `Hspec.shouldSatisfy` Either.isLeft
      test $ f (-1) `Hspec.shouldSatisfy` Either.isLeft

    Hspec.describe "TryCast Int64 Word16" $ do
      let f = Witch.tryCast @Int.Int64 @Word.Word16
      test $ f 0 `Hspec.shouldBe` Right 0
      test $ f 65535 `Hspec.shouldBe` Right 65535
      test $ f 65536 `Hspec.shouldSatisfy` Either.isLeft
      test $ f (-1) `Hspec.shouldSatisfy` Either.isLeft

    Hspec.describe "TryCast Int64 Word32" $ do
      let f = Witch.tryCast @Int.Int64 @Word.Word32
      test $ f 0 `Hspec.shouldBe` Right 0
      test $ f 2147483647 `Hspec.shouldBe` Right 2147483647
      test $ f (-1) `Hspec.shouldSatisfy` Either.isLeft

    Hspec.describe "TryCast Int64 Word64" $ do
      let f = Witch.tryCast @Int.Int64 @Word.Word64
      test $ f 0 `Hspec.shouldBe` Right 0
      test $ f 9223372036854775807 `Hspec.shouldBe` Right 9223372036854775807
      test $ f (-1) `Hspec.shouldSatisfy` Either.isLeft

    Hspec.describe "TryCast Int64 Word" $ do
      Monad.when (toInteger (maxBound :: Word) < 9223372036854775807) untested
      let f = Witch.tryCast @Int.Int64 @Word
      test $ f 0 `Hspec.shouldBe` Right 0
      test $ f 9223372036854775807 `Hspec.shouldBe` Right 9223372036854775807
      test $ f (-1) `Hspec.shouldSatisfy` Either.isLeft

    Hspec.describe "TryCast Int64 Natural" $ do
      let f = Witch.tryCast @Int.Int64 @Natural.Natural
      test $ f 0 `Hspec.shouldBe` Right 0
      test $ f 9223372036854775807 `Hspec.shouldBe` Right 9223372036854775807
      test $ f (-1) `Hspec.shouldSatisfy` Either.isLeft

    Hspec.describe "TryCast Int64 Float" $ do
      let f = Witch.tryCast @Int.Int64 @Float
      test $ f 0 `Hspec.shouldBe` Right 0
      test $ f 16777215 `Hspec.shouldBe` Right 16777215
      test $ f 16777216 `Hspec.shouldSatisfy` Either.isLeft
      test $ f (-16777215) `Hspec.shouldBe` Right (-16777215)
      test $ f (-16777216) `Hspec.shouldSatisfy` Either.isLeft

    Hspec.describe "TryCast Int64 Double" $ do
      let f = Witch.tryCast @Int.Int64 @Double
      test $ f 0 `Hspec.shouldBe` Right 0
      test $ f 9007199254740991 `Hspec.shouldBe` Right 9007199254740991
      test $ f 9007199254740992 `Hspec.shouldSatisfy` Either.isLeft
      test $ f (-9007199254740991) `Hspec.shouldBe` Right (-9007199254740991)
      test $ f (-9007199254740992) `Hspec.shouldSatisfy` Either.isLeft

    -- Int

    Hspec.describe "TryCast Int Int8" $ do
      let f = Witch.tryCast @Int @Int.Int8
      test $ f 0 `Hspec.shouldBe` Right 0
      test $ f 127 `Hspec.shouldBe` Right 127
      test $ f 128 `Hspec.shouldSatisfy` Either.isLeft
      test $ f (-128) `Hspec.shouldBe` Right (-128)
      test $ f (-129) `Hspec.shouldSatisfy` Either.isLeft

    Hspec.describe "TryCast Int Int16" $ do
      let f = Witch.tryCast @Int @Int.Int16
      test $ f 0 `Hspec.shouldBe` Right 0
      test $ f 32767 `Hspec.shouldBe` Right 32767
      test $ f 32768 `Hspec.shouldSatisfy` Either.isLeft
      test $ f (-32768) `Hspec.shouldBe` Right (-32768)
      test $ f (-32769) `Hspec.shouldSatisfy` Either.isLeft

    Hspec.describe "TryCast Int Int32" $ do
      Monad.when (toInteger (maxBound :: Int) < 2147483647) untested
      let f = Witch.tryCast @Int @Int.Int32
      test $ f 0 `Hspec.shouldBe` Right 0
      test $ f 2147483647 `Hspec.shouldBe` Right 2147483647
      test $ f 2147483648 `Hspec.shouldSatisfy` Either.isLeft
      test $ f (-2147483648) `Hspec.shouldBe` Right (-2147483648)
      test $ f (-2147483649) `Hspec.shouldSatisfy` Either.isLeft

    Hspec.describe "Cast Int Int64" $ do
      let f = Witch.cast @Int @Int.Int64
      test $ f 0 `Hspec.shouldBe` 0
      test $ f maxBound `Hspec.shouldBe` fromIntegral (maxBound :: Int)
      test $ f minBound `Hspec.shouldBe` fromIntegral (minBound :: Int)

    Hspec.describe "Cast Int Integer" $ do
      let f = Witch.cast @Int @Integer
      test $ f 0 `Hspec.shouldBe` 0
      test $ f maxBound `Hspec.shouldBe` fromIntegral (maxBound :: Int)
      test $ f minBound `Hspec.shouldBe` fromIntegral (minBound :: Int)

    Hspec.describe "TryCast Int Word8" $ do
      let f = Witch.tryCast @Int @Word.Word8
      test $ f 0 `Hspec.shouldBe` Right 0
      test $ f 255 `Hspec.shouldBe` Right 255
      test $ f 256 `Hspec.shouldSatisfy` Either.isLeft
      test $ f (-1) `Hspec.shouldSatisfy` Either.isLeft

    Hspec.describe "TryCast Int Word16" $ do
      let f = Witch.tryCast @Int @Word.Word16
      test $ f 0 `Hspec.shouldBe` Right 0
      test $ f 65535 `Hspec.shouldBe` Right 65535
      test $ f 65536 `Hspec.shouldSatisfy` Either.isLeft
      test $ f (-1) `Hspec.shouldSatisfy` Either.isLeft

    Hspec.describe "TryCast Int Word32" $ do
      Monad.when (toInteger (maxBound :: Int) < 4294967295) untested
      let f = Witch.tryCast @Int @Word.Word32
      test $ f 0 `Hspec.shouldBe` Right 0
      test $ f 4294967295 `Hspec.shouldBe` Right 4294967295
      test $ f 4294967296 `Hspec.shouldSatisfy` Either.isLeft
      test $ f (-1) `Hspec.shouldSatisfy` Either.isLeft

    Hspec.describe "TryCast Int Word64" $ do
      let f = Witch.tryCast @Int @Word.Word64
      test $ f 0 `Hspec.shouldBe` Right 0
      test $ f maxBound `Hspec.shouldBe` Right (fromIntegral (maxBound :: Int))
      test $ f (-1) `Hspec.shouldSatisfy` Either.isLeft

    Hspec.describe "TryCast Int Word" $ do
      let f = Witch.tryCast @Int @Word
      test $ f 0 `Hspec.shouldBe` Right 0
      test $ f maxBound `Hspec.shouldBe` Right (fromIntegral (maxBound :: Int))
      test $ f (-1) `Hspec.shouldSatisfy` Either.isLeft

    Hspec.describe "TryCast Int Natural" $ do
      let f = Witch.tryCast @Int @Natural.Natural
      test $ f 0 `Hspec.shouldBe` Right 0
      test $ f maxBound `Hspec.shouldBe` Right (fromIntegral (maxBound :: Int))
      test $ f (-1) `Hspec.shouldSatisfy` Either.isLeft

    Hspec.describe "TryCast Int Float" $ do
      let f = Witch.tryCast @Int @Float
      test $ f 0 `Hspec.shouldBe` Right 0
      test $ f 16777215 `Hspec.shouldBe` Right 16777215
      test $ f 16777216 `Hspec.shouldSatisfy` Either.isLeft
      test $ f (-16777215) `Hspec.shouldBe` Right (-16777215)
      test $ f (-16777216) `Hspec.shouldSatisfy` Either.isLeft

    Hspec.describe "TryCast Int Double" $ do
      Monad.when (toInteger (maxBound :: Int) < 9007199254740991) untested
      let f = Witch.tryCast @Int @Double
      test $ f 0 `Hspec.shouldBe` Right 0
      test $ f 9007199254740991 `Hspec.shouldBe` Right 9007199254740991
      test $ f 9007199254740992 `Hspec.shouldSatisfy` Either.isLeft
      test $ f (-9007199254740991) `Hspec.shouldBe` Right (-9007199254740991)
      test $ f (-9007199254740992) `Hspec.shouldSatisfy` Either.isLeft

    -- Integer

    Hspec.describe "TryCast Integer Int8" $ do
      let f = Witch.tryCast @Integer @Int.Int8
      test $ f 0 `Hspec.shouldBe` Right 0
      test $ f 127 `Hspec.shouldBe` Right 127
      test $ f 128 `Hspec.shouldSatisfy` Either.isLeft
      test $ f (-128) `Hspec.shouldBe` Right (-128)
      test $ f (-129) `Hspec.shouldSatisfy` Either.isLeft

    Hspec.describe "TryCast Integer Int16" $ do
      let f = Witch.tryCast @Integer @Int.Int16
      test $ f 0 `Hspec.shouldBe` Right 0
      test $ f 32767 `Hspec.shouldBe` Right 32767
      test $ f 32768 `Hspec.shouldSatisfy` Either.isLeft
      test $ f (-32768) `Hspec.shouldBe` Right (-32768)
      test $ f (-32769) `Hspec.shouldSatisfy` Either.isLeft

    Hspec.describe "TryCast Integer Int32" $ do
      let f = Witch.tryCast @Integer @Int.Int32
      test $ f 0 `Hspec.shouldBe` Right 0
      test $ f 2147483647 `Hspec.shouldBe` Right 2147483647
      test $ f 2147483648 `Hspec.shouldSatisfy` Either.isLeft
      test $ f (-2147483648) `Hspec.shouldBe` Right (-2147483648)
      test $ f (-2147483649) `Hspec.shouldSatisfy` Either.isLeft

    Hspec.describe "TryCast Integer Int64" $ do
      let f = Witch.tryCast @Integer @Int.Int64
      test $ f 0 `Hspec.shouldBe` Right 0
      test $ f 9223372036854775807 `Hspec.shouldBe` Right 9223372036854775807
      test $ f 9223372036854775808 `Hspec.shouldSatisfy` Either.isLeft
      test $ f (-9223372036854775808) `Hspec.shouldBe` Right (-9223372036854775808)
      test $ f (-9223372036854775809) `Hspec.shouldSatisfy` Either.isLeft

    Hspec.describe "TryCast Integer Int" $ do
      let f = Witch.tryCast @Integer @Int
      test $ f 0 `Hspec.shouldBe` Right 0
      test $ let x = maxBound :: Int in f (fromIntegral x) `Hspec.shouldBe` Right x
      test $ let x = toInteger (maxBound :: Int) + 1 in f x `Hspec.shouldSatisfy` Either.isLeft
      test $ let x = minBound :: Int in f (fromIntegral x) `Hspec.shouldBe` Right x
      test $ let x = toInteger (minBound :: Int) - 1 in f x `Hspec.shouldSatisfy` Either.isLeft

    Hspec.describe "TryCast Integer Word8" $ do
      let f = Witch.tryCast @Integer @Word.Word8
      test $ f 0 `Hspec.shouldBe` Right 0
      test $ f 255 `Hspec.shouldBe` Right 255
      test $ f 256 `Hspec.shouldSatisfy` Either.isLeft
      test $ f (-1) `Hspec.shouldSatisfy` Either.isLeft

    Hspec.describe "TryCast Integer Word16" $ do
      let f = Witch.tryCast @Integer @Word.Word16
      test $ f 0 `Hspec.shouldBe` Right 0
      test $ f 65535 `Hspec.shouldBe` Right 65535
      test $ f 65536 `Hspec.shouldSatisfy` Either.isLeft
      test $ f (-1) `Hspec.shouldSatisfy` Either.isLeft

    Hspec.describe "TryCast Integer Word32" $ do
      let f = Witch.tryCast @Integer @Word.Word32
      test $ f 0 `Hspec.shouldBe` Right 0
      test $ f 4294967295 `Hspec.shouldBe` Right 4294967295
      test $ f 4294967296 `Hspec.shouldSatisfy` Either.isLeft
      test $ f (-1) `Hspec.shouldSatisfy` Either.isLeft

    Hspec.describe "TryCast Integer Word64" $ do
      let f = Witch.tryCast @Integer @Word.Word64
      test $ f 0 `Hspec.shouldBe` Right 0
      test $ f 18446744073709551615 `Hspec.shouldBe` Right 18446744073709551615
      test $ f 18446744073709551616 `Hspec.shouldSatisfy` Either.isLeft
      test $ f (-1) `Hspec.shouldSatisfy` Either.isLeft

    Hspec.describe "TryCast Integer Word" $ do
      let f = Witch.tryCast @Integer @Word
      test $ f 0 `Hspec.shouldBe` Right 0
      test $ let x = maxBound :: Word in f (fromIntegral x) `Hspec.shouldBe` Right x
      test $ let x = toInteger (maxBound :: Word) + 1 in f x `Hspec.shouldSatisfy` Either.isLeft
      test $ f (-1) `Hspec.shouldSatisfy` Either.isLeft

    Hspec.describe "TryCast Integer Natural" $ do
      let f = Witch.tryCast @Integer @Natural.Natural
      test $ f 0 `Hspec.shouldBe` Right 0
      test $ f 18446744073709551616 `Hspec.shouldBe` Right 18446744073709551616
      test $ f (-1) `Hspec.shouldSatisfy` Either.isLeft

    Hspec.describe "TryCast Integer Float" $ do
      let f = Witch.tryCast @Integer @Float
      test $ f 0 `Hspec.shouldBe` Right 0
      test $ f 16777215 `Hspec.shouldBe` Right 16777215
      test $ f 16777216 `Hspec.shouldSatisfy` Either.isLeft
      test $ f (-16777215) `Hspec.shouldBe` Right (-16777215)
      test $ f (-16777216) `Hspec.shouldSatisfy` Either.isLeft

    Hspec.describe "TryCast Integer Double" $ do
      let f = Witch.tryCast @Integer @Double
      test $ f 0 `Hspec.shouldBe` Right 0
      test $ f 9007199254740991 `Hspec.shouldBe` Right 9007199254740991
      test $ f 9007199254740992 `Hspec.shouldSatisfy` Either.isLeft
      test $ f (-9007199254740991) `Hspec.shouldBe` Right (-9007199254740991)
      test $ f (-9007199254740992) `Hspec.shouldSatisfy` Either.isLeft

    -- Word8

    Hspec.describe "Cast Word8 Word16" $ do
      let f = Witch.cast @Word.Word8 @Word.Word16
      test $ f 0 `Hspec.shouldBe` 0
      test $ f 255 `Hspec.shouldBe` 255

    Hspec.describe "Cast Word8 Word32" $ do
      let f = Witch.cast @Word.Word8 @Word.Word32
      test $ f 0 `Hspec.shouldBe` 0
      test $ f 255 `Hspec.shouldBe` 255

    Hspec.describe "Cast Word8 Word64" $ do
      let f = Witch.cast @Word.Word8 @Word.Word64
      test $ f 0 `Hspec.shouldBe` 0
      test $ f 255 `Hspec.shouldBe` 255

    Hspec.describe "Cast Word8 Word" $ do
      let f = Witch.cast @Word.Word8 @Word
      test $ f 0 `Hspec.shouldBe` 0
      test $ f 255 `Hspec.shouldBe` 255

    Hspec.describe "Cast Word8 Natural" $ do
      let f = Witch.cast @Word.Word8 @Natural.Natural
      test $ f 0 `Hspec.shouldBe` 0
      test $ f 255 `Hspec.shouldBe` 255

    Hspec.describe "TryCast Word8 Int8" $ do
      let f = Witch.tryCast @Word.Word8 @Int.Int8
      test $ f 0 `Hspec.shouldBe` Right 0
      test $ f 127 `Hspec.shouldBe` Right 127
      test $ f 128 `Hspec.shouldSatisfy` Either.isLeft

    Hspec.describe "Cast Word8 Int16" $ do
      let f = Witch.cast @Word.Word8 @Int.Int16
      test $ f 0 `Hspec.shouldBe` 0
      test $ f 255 `Hspec.shouldBe` 255

    Hspec.describe "Cast Word8 Int32" $ do
      let f = Witch.cast @Word.Word8 @Int.Int32
      test $ f 0 `Hspec.shouldBe` 0
      test $ f 255 `Hspec.shouldBe` 255

    Hspec.describe "Cast Word8 Int64" $ do
      let f = Witch.cast @Word.Word8 @Int.Int64
      test $ f 0 `Hspec.shouldBe` 0
      test $ f 255 `Hspec.shouldBe` 255

    Hspec.describe "Cast Word8 Int" $ do
      let f = Witch.cast @Word.Word8 @Int
      test $ f 0 `Hspec.shouldBe` 0
      test $ f 255 `Hspec.shouldBe` 255

    Hspec.describe "Cast Word8 Integer" $ do
      let f = Witch.cast @Word.Word8 @Integer
      test $ f 0 `Hspec.shouldBe` 0
      test $ f 255 `Hspec.shouldBe` 255

    Hspec.describe "Cast Word8 Float" $ do
      let f = Witch.cast @Word.Word8 @Float
      test $ f 0 `Hspec.shouldBe` 0
      test $ f 255 `Hspec.shouldBe` 255

    Hspec.describe "Cast Word8 Double" $ do
      let f = Witch.cast @Word.Word8 @Double
      test $ f 0 `Hspec.shouldBe` 0
      test $ f 255 `Hspec.shouldBe` 255

    -- Word16

    Hspec.describe "TryCast Word16 Word8" $ do
      let f = Witch.tryCast @Word.Word16 @Word.Word8
      test $ f 0 `Hspec.shouldBe` Right 0
      test $ f 255 `Hspec.shouldBe` Right 255
      test $ f 256 `Hspec.shouldSatisfy` Either.isLeft

    Hspec.describe "Cast Word16 Word32" $ do
      let f = Witch.cast @Word.Word16 @Word.Word32
      test $ f 0 `Hspec.shouldBe` 0
      test $ f 65535 `Hspec.shouldBe` 65535

    Hspec.describe "Cast Word16 Word64" $ do
      let f = Witch.cast @Word.Word16 @Word.Word64
      test $ f 0 `Hspec.shouldBe` 0
      test $ f 65535 `Hspec.shouldBe` 65535

    Hspec.describe "Cast Word16 Word" $ do
      let f = Witch.cast @Word.Word16 @Word
      test $ f 0 `Hspec.shouldBe` 0
      test $ f 65535 `Hspec.shouldBe` 65535

    Hspec.describe "Cast Word16 Natural" $ do
      let f = Witch.cast @Word.Word16 @Natural.Natural
      test $ f 0 `Hspec.shouldBe` 0
      test $ f 65535 `Hspec.shouldBe` 65535

    Hspec.describe "TryCast Word16 Int8" $ do
      let f = Witch.tryCast @Word.Word16 @Int.Int8
      test $ f 0 `Hspec.shouldBe` Right 0
      test $ f 127 `Hspec.shouldBe` Right 127
      test $ f 128 `Hspec.shouldSatisfy` Either.isLeft

    Hspec.describe "TryCast Word16 Int16" $ do
      let f = Witch.tryCast @Word.Word16 @Int.Int16
      test $ f 0 `Hspec.shouldBe` Right 0
      test $ f 32767 `Hspec.shouldBe` Right 32767
      test $ f 32768 `Hspec.shouldSatisfy` Either.isLeft

    Hspec.describe "Cast Word16 Int32" $ do
      let f = Witch.cast @Word.Word16 @Int.Int32
      test $ f 0 `Hspec.shouldBe` 0
      test $ f 65535 `Hspec.shouldBe` 65535

    Hspec.describe "Cast Word16 Int64" $ do
      let f = Witch.cast @Word.Word16 @Int.Int64
      test $ f 0 `Hspec.shouldBe` 0
      test $ f 65535 `Hspec.shouldBe` 65535

    Hspec.describe "Cast Word16 Int" $ do
      let f = Witch.cast @Word.Word16 @Int
      test $ f 0 `Hspec.shouldBe` 0
      test $ f 65535 `Hspec.shouldBe` 65535

    Hspec.describe "Cast Word16 Integer" $ do
      let f = Witch.cast @Word.Word16 @Integer
      test $ f 0 `Hspec.shouldBe` 0
      test $ f 65535 `Hspec.shouldBe` 65535

    Hspec.describe "Cast Word16 Float" $ do
      let f = Witch.cast @Word.Word16 @Float
      test $ f 0 `Hspec.shouldBe` 0
      test $ f 65535 `Hspec.shouldBe` 65535

    Hspec.describe "Cast Word16 Double" $ do
      let f = Witch.cast @Word.Word16 @Double
      test $ f 0 `Hspec.shouldBe` 0
      test $ f 65535 `Hspec.shouldBe` 65535

    -- Word32

    Hspec.describe "TryCast Word32 Word8" $ do
      let f = Witch.tryCast @Word.Word32 @Word.Word8
      test $ f 0 `Hspec.shouldBe` Right 0
      test $ f 255 `Hspec.shouldBe` Right 255
      test $ f 256 `Hspec.shouldSatisfy` Either.isLeft

    Hspec.describe "TryCast Word32 Word16" $ do
      let f = Witch.tryCast @Word.Word32 @Word.Word16
      test $ f 0 `Hspec.shouldBe` Right 0
      test $ f 65535 `Hspec.shouldBe` Right 65535
      test $ f 65536 `Hspec.shouldSatisfy` Either.isLeft

    Hspec.describe "Cast Word32 Word64" $ do
      let f = Witch.cast @Word.Word32 @Word.Word64
      test $ f 0 `Hspec.shouldBe` 0
      test $ f 4294967295 `Hspec.shouldBe` 4294967295

    Hspec.describe "TryCast Word32 Word" $ do
      Monad.when (toInteger (maxBound :: Word) < 4294967295) untested
      let f = Witch.tryCast @Word.Word32 @Word
      test $ f 0 `Hspec.shouldBe` Right 0
      test $ f 4294967295 `Hspec.shouldBe` Right 4294967295

    Hspec.describe "Cast Word32 Natural" $ do
      let f = Witch.cast @Word.Word32 @Natural.Natural
      test $ f 0 `Hspec.shouldBe` 0
      test $ f 4294967295 `Hspec.shouldBe` 4294967295

    Hspec.describe "TryCast Word32 Int8" $ do
      let f = Witch.tryCast @Word.Word32 @Int.Int8
      test $ f 0 `Hspec.shouldBe` Right 0
      test $ f 127 `Hspec.shouldBe` Right 127
      test $ f 128 `Hspec.shouldSatisfy` Either.isLeft

    Hspec.describe "TryCast Word32 Int16" $ do
      let f = Witch.tryCast @Word.Word32 @Int.Int16
      test $ f 0 `Hspec.shouldBe` Right 0
      test $ f 32767 `Hspec.shouldBe` Right 32767
      test $ f 32768 `Hspec.shouldSatisfy` Either.isLeft

    Hspec.describe "TryCast Word32 Int32" $ do
      let f = Witch.tryCast @Word.Word32 @Int.Int32
      test $ f 0 `Hspec.shouldBe` Right 0
      test $ f 2147483647 `Hspec.shouldBe` Right 2147483647
      test $ f 2147483648 `Hspec.shouldSatisfy` Either.isLeft

    Hspec.describe "Cast Word32 Int64" $ do
      let f = Witch.cast @Word.Word32 @Int.Int64
      test $ f 0 `Hspec.shouldBe` 0
      test $ f 4294967295 `Hspec.shouldBe` 4294967295

    Hspec.describe "TryCast Word32 Int" $ do
      Monad.when (toInteger (maxBound :: Int) < 4294967295) untested
      let f = Witch.tryCast @Word.Word32 @Int
      test $ f 0 `Hspec.shouldBe` Right 0
      test $ f 4294967295 `Hspec.shouldBe` Right 4294967295

    Hspec.describe "Cast Word32 Integer" $ do
      let f = Witch.cast @Word.Word32 @Integer
      test $ f 0 `Hspec.shouldBe` 0
      test $ f 4294967295 `Hspec.shouldBe` 4294967295

    Hspec.describe "TryCast Word32 Float" $ do
      let f = Witch.tryCast @Word.Word32 @Float
      test $ f 0 `Hspec.shouldBe` Right 0
      test $ f 16777215 `Hspec.shouldBe` Right 16777215
      test $ f 16777216 `Hspec.shouldSatisfy` Either.isLeft

    Hspec.describe "Cast Word32 Double" $ do
      let f = Witch.cast @Word.Word32 @Double
      test $ f 0 `Hspec.shouldBe` 0
      test $ f 4294967295 `Hspec.shouldBe` 4294967295

    -- Word64

    Hspec.describe "TryCast Word64 Word8" $ do
      let f = Witch.tryCast @Word.Word64 @Word.Word8
      test $ f 0 `Hspec.shouldBe` Right 0
      test $ f 255 `Hspec.shouldBe` Right 255
      test $ f 256 `Hspec.shouldSatisfy` Either.isLeft

    Hspec.describe "TryCast Word64 Word16" $ do
      let f = Witch.tryCast @Word.Word64 @Word.Word16
      test $ f 0 `Hspec.shouldBe` Right 0
      test $ f 65535 `Hspec.shouldBe` Right 65535
      test $ f 65536 `Hspec.shouldSatisfy` Either.isLeft

    Hspec.describe "TryCast Word64 Word32" $ do
      let f = Witch.tryCast @Word.Word64 @Word.Word32
      test $ f 0 `Hspec.shouldBe` Right 0
      test $ f 4294967295 `Hspec.shouldBe` Right 4294967295
      test $ f 4294967296 `Hspec.shouldSatisfy` Either.isLeft

    Hspec.describe "TryCast Word64 Word" $ do
      Monad.when (toInteger (maxBound :: Word) < 18446744073709551615) untested
      let f = Witch.tryCast @Word.Word64 @Word
      test $ f 0 `Hspec.shouldBe` Right 0
      test $ f 18446744073709551615 `Hspec.shouldBe` Right 18446744073709551615

    Hspec.describe "Cast Word64 Natural" $ do
      let f = Witch.cast @Word.Word64 @Natural.Natural
      test $ f 0 `Hspec.shouldBe` 0
      test $ f 18446744073709551615 `Hspec.shouldBe` 18446744073709551615

    Hspec.describe "TryCast Word64 Int8" $ do
      let f = Witch.tryCast @Word.Word64 @Int.Int8
      test $ f 0 `Hspec.shouldBe` Right 0
      test $ f 127 `Hspec.shouldBe` Right 127
      test $ f 128 `Hspec.shouldSatisfy` Either.isLeft

    Hspec.describe "TryCast Word64 Int16" $ do
      let f = Witch.tryCast @Word.Word64 @Int.Int16
      test $ f 0 `Hspec.shouldBe` Right 0
      test $ f 32767 `Hspec.shouldBe` Right 32767
      test $ f 32768 `Hspec.shouldSatisfy` Either.isLeft

    Hspec.describe "TryCast Word64 Int32" $ do
      let f = Witch.tryCast @Word.Word64 @Int.Int32
      test $ f 0 `Hspec.shouldBe` Right 0
      test $ f 2147483647 `Hspec.shouldBe` Right 2147483647
      test $ f 2147483648 `Hspec.shouldSatisfy` Either.isLeft

    Hspec.describe "TryCast Word64 Int64" $ do
      let f = Witch.tryCast @Word.Word64 @Int.Int64
      test $ f 0 `Hspec.shouldBe` Right 0
      test $ f 9223372036854775807 `Hspec.shouldBe` Right 9223372036854775807
      test $ f 9223372036854775808 `Hspec.shouldSatisfy` Either.isLeft

    Hspec.describe "TryCast Word64 Int" $ do
      let f = Witch.tryCast @Word.Word64 @Int
      test $ f 0 `Hspec.shouldBe` Right 0
      test $ let x = maxBound :: Int in Witch.tryCast @Word.Word64 @Int (fromIntegral x) `Hspec.shouldBe` Right x
      test $ let x = fromIntegral (maxBound :: Int) + 1 :: Word.Word64 in Witch.tryCast @Word.Word64 @Int x `Hspec.shouldSatisfy` Either.isLeft

    Hspec.describe "Cast Word64 Integer" $ do
      let f = Witch.cast @Word.Word64 @Integer
      test $ f 0 `Hspec.shouldBe` 0
      test $ f 18446744073709551615 `Hspec.shouldBe` 18446744073709551615

    Hspec.describe "TryCast Word64 Float" $ do
      let f = Witch.tryCast @Word.Word64 @Float
      test $ f 0 `Hspec.shouldBe` Right 0
      test $ f 16777215 `Hspec.shouldBe` Right 16777215
      test $ f 16777216 `Hspec.shouldSatisfy` Either.isLeft

    Hspec.describe "TryCast Word64 Double" $ do
      let f = Witch.tryCast @Word.Word64 @Double
      test $ f 0 `Hspec.shouldBe` Right 0
      test $ f 9007199254740991 `Hspec.shouldBe` Right 9007199254740991
      test $ f 9007199254740992 `Hspec.shouldSatisfy` Either.isLeft

    -- Word

    Hspec.describe "TryCast Word Word8" $ do
      let f = Witch.tryCast @Word @Word.Word8
      test $ f 0 `Hspec.shouldBe` Right 0
      test $ f 255 `Hspec.shouldBe` Right 255
      test $ f 256 `Hspec.shouldSatisfy` Either.isLeft

    Hspec.describe "TryCast Word Word16" $ do
      let f = Witch.tryCast @Word @Word.Word16
      test $ f 0 `Hspec.shouldBe` Right 0
      test $ f 65535 `Hspec.shouldBe` Right 65535
      test $ f 65536 `Hspec.shouldSatisfy` Either.isLeft

    Hspec.describe "TryCast Word Word32" $ do
      Monad.when (toInteger (maxBound :: Word) < 4294967295) untested
      let f = Witch.tryCast @Word @Word.Word32
      test $ f 0 `Hspec.shouldBe` Right 0
      test $ f 4294967295 `Hspec.shouldBe` Right 4294967295
      test $ f 4294967296 `Hspec.shouldSatisfy` Either.isLeft

    Hspec.describe "Cast Word Word64" $ do
      let f = Witch.cast @Word @Word.Word64
      test $ f 0 `Hspec.shouldBe` 0
      test $ f maxBound `Hspec.shouldBe` fromIntegral (maxBound :: Word)

    Hspec.describe "Cast Word Natural" $ do
      let f = Witch.cast @Word @Natural.Natural
      test $ f 0 `Hspec.shouldBe` 0
      test $ f maxBound `Hspec.shouldBe` fromIntegral (maxBound :: Word)

    Hspec.describe "TryCast Word Int8" $ do
      let f = Witch.tryCast @Word @Int.Int8
      test $ f 0 `Hspec.shouldBe` Right 0
      test $ f 127 `Hspec.shouldBe` Right 127
      test $ f 128 `Hspec.shouldSatisfy` Either.isLeft

    Hspec.describe "TryCast Word Int16" $ do
      let f = Witch.tryCast @Word @Int.Int16
      test $ f 0 `Hspec.shouldBe` Right 0
      test $ f 32767 `Hspec.shouldBe` Right 32767
      test $ f 32768 `Hspec.shouldSatisfy` Either.isLeft

    Hspec.describe "TryCast Word Int32" $ do
      Monad.when (toInteger (maxBound :: Word) < 2147483647) untested
      let f = Witch.tryCast @Word @Int.Int32
      test $ f 0 `Hspec.shouldBe` Right 0
      test $ f 2147483647 `Hspec.shouldBe` Right 2147483647
      test $ f 2147483648 `Hspec.shouldSatisfy` Either.isLeft

    Hspec.describe "TryCast Word Int64" $ do
      Monad.when (toInteger (maxBound :: Word) < 9223372036854775807) untested
      let f = Witch.tryCast @Word @Int.Int64
      test $ f 0 `Hspec.shouldBe` Right 0
      test $ f 9223372036854775807 `Hspec.shouldBe` Right 9223372036854775807
      test $ f 9223372036854775808 `Hspec.shouldSatisfy` Either.isLeft

    Hspec.describe "TryCast Word Int" $ do
      let f = Witch.tryCast @Word @Int
      test $ f 0 `Hspec.shouldBe` Right 0
      test $ let x = maxBound :: Int in Witch.tryCast @Word @Int (fromIntegral x) `Hspec.shouldBe` Right x
      test $ let x = fromIntegral (maxBound :: Int) + 1 :: Word in Witch.tryCast @Word @Int x `Hspec.shouldSatisfy` Either.isLeft

    Hspec.describe "Cast Word Integer" $ do
      let f = Witch.cast @Word @Integer
      test $ f 0 `Hspec.shouldBe` 0
      test $ f maxBound `Hspec.shouldBe` fromIntegral (maxBound :: Word)

    Hspec.describe "TryCast Word Float" $ do
      let f = Witch.tryCast @Word @Float
      test $ f 0 `Hspec.shouldBe` Right 0
      test $ f 16777215 `Hspec.shouldBe` Right 16777215
      test $ f 16777216 `Hspec.shouldSatisfy` Either.isLeft

    Hspec.describe "TryCast Word Double" $ do
      Monad.when (toInteger (maxBound :: Word) < 9007199254740991) untested
      let f = Witch.tryCast @Word @Double
      test $ f 0 `Hspec.shouldBe` Right 0
      test $ f 9007199254740991 `Hspec.shouldBe` Right 9007199254740991
      test $ f 9007199254740992 `Hspec.shouldSatisfy` Either.isLeft

    -- Natural

    Hspec.describe "TryCast Natural Word8" $ do
      let f = Witch.tryCast @Natural.Natural @Word.Word8
      test $ f 0 `Hspec.shouldBe` Right 0
      test $ f 255 `Hspec.shouldBe` Right 255
      test $ f 256 `Hspec.shouldSatisfy` Either.isLeft

    Hspec.describe "TryCast Natural Word16" $ do
      let f = Witch.tryCast @Natural.Natural @Word.Word16
      test $ f 0 `Hspec.shouldBe` Right 0
      test $ f 65535 `Hspec.shouldBe` Right 65535
      test $ f 65536 `Hspec.shouldSatisfy` Either.isLeft

    Hspec.describe "TryCast Natural Word32" $ do
      let f = Witch.tryCast @Natural.Natural @Word.Word32
      test $ f 0 `Hspec.shouldBe` Right 0
      test $ f 4294967295 `Hspec.shouldBe` Right 4294967295
      test $ f 4294967296 `Hspec.shouldSatisfy` Either.isLeft

    Hspec.describe "TryCast Natural Word64" $ do
      let f = Witch.tryCast @Natural.Natural @Word.Word64
      test $ f 0 `Hspec.shouldBe` Right 0
      test $ f 18446744073709551615 `Hspec.shouldBe` Right 18446744073709551615
      test $ f 18446744073709551616 `Hspec.shouldSatisfy` Either.isLeft

    Hspec.describe "TryCast Natural Word" $ do
      let f = Witch.tryCast @Natural.Natural @Word
      test $ f 0 `Hspec.shouldBe` Right 0
      test $ let x = maxBound :: Word in Witch.tryCast @Natural.Natural @Word (fromIntegral x) `Hspec.shouldBe` Right x
      test $ let x = fromIntegral (maxBound :: Word) + 1 :: Natural.Natural in Witch.tryCast @Natural.Natural @Word x `Hspec.shouldSatisfy` Either.isLeft

    Hspec.describe "TryCast Natural Int8" $ do
      let f = Witch.tryCast @Natural.Natural @Int.Int8
      test $ f 0 `Hspec.shouldBe` Right 0
      test $ f 127 `Hspec.shouldBe` Right 127
      test $ f 128 `Hspec.shouldSatisfy` Either.isLeft

    Hspec.describe "TryCast Natural Int16" $ do
      let f = Witch.tryCast @Natural.Natural @Int.Int16
      test $ f 0 `Hspec.shouldBe` Right 0
      test $ f 32767 `Hspec.shouldBe` Right 32767
      test $ f 32768 `Hspec.shouldSatisfy` Either.isLeft

    Hspec.describe "TryCast Natural Int32" $ do
      let f = Witch.tryCast @Natural.Natural @Int.Int32
      test $ f 0 `Hspec.shouldBe` Right 0
      test $ f 2147483647 `Hspec.shouldBe` Right 2147483647
      test $ f 2147483648 `Hspec.shouldSatisfy` Either.isLeft

    Hspec.describe "TryCast Natural Int64" $ do
      let f = Witch.tryCast @Natural.Natural @Int.Int64
      test $ f 0 `Hspec.shouldBe` Right 0
      test $ f 9223372036854775807 `Hspec.shouldBe` Right 9223372036854775807
      test $ f 9223372036854775808 `Hspec.shouldSatisfy` Either.isLeft

    Hspec.describe "TryCast Natural Int" $ do
      let f = Witch.tryCast @Natural.Natural @Int
      test $ f 0 `Hspec.shouldBe` Right 0
      test $ let x = maxBound :: Int in Witch.tryCast @Natural.Natural @Int (fromIntegral x) `Hspec.shouldBe` Right x
      test $ let x = fromIntegral (maxBound :: Int) + 1 :: Natural.Natural in Witch.tryCast @Natural.Natural @Int x `Hspec.shouldSatisfy` Either.isLeft

    Hspec.describe "Cast Natural Integer" $ do
      let f = Witch.cast @Natural.Natural @Integer
      test $ f 0 `Hspec.shouldBe` 0
      test $ f 9223372036854775808 `Hspec.shouldBe` 9223372036854775808

    Hspec.describe "TryCast Natural Float" $ do
      let f = Witch.tryCast @Natural.Natural @Float
      test $ f 0 `Hspec.shouldBe` Right 0
      test $ f 16777215 `Hspec.shouldBe` Right 16777215
      test $ f 16777216 `Hspec.shouldSatisfy` Either.isLeft

    Hspec.describe "TryCast Natural Double" $ do
      let f = Witch.tryCast @Natural.Natural @Double
      test $ f 0 `Hspec.shouldBe` Right 0
      test $ f 9007199254740991 `Hspec.shouldBe` Right 9007199254740991
      test $ f 9007199254740992 `Hspec.shouldSatisfy` Either.isLeft

    -- Float

    Hspec.describe "TryCast Float Int8" $ do
      let f = Witch.tryCast @Float @Int.Int8
      test $ f 0 `Hspec.shouldBe` Right 0
      test $ f 127 `Hspec.shouldBe` Right 127
      test $ f 128 `Hspec.shouldSatisfy` Either.isLeft
      test $ f (-128) `Hspec.shouldBe` Right (-128)
      test $ f (-129) `Hspec.shouldSatisfy` Either.isLeft
      test $ f (0 / 0) `Hspec.shouldSatisfy` Either.isLeft
      test $ f (1 / 0) `Hspec.shouldSatisfy` Either.isLeft
      test $ f (-1 / 0) `Hspec.shouldSatisfy` Either.isLeft

    Hspec.describe "TryCast Float Int16" $ do
      let f = Witch.tryCast @Float @Int.Int16
      test $ f 0 `Hspec.shouldBe` Right 0
      test $ f 32767 `Hspec.shouldBe` Right 32767
      test $ f 32768 `Hspec.shouldSatisfy` Either.isLeft
      test $ f (-32768) `Hspec.shouldBe` Right (-32768)
      test $ f (-32769) `Hspec.shouldSatisfy` Either.isLeft
      test $ f (0 / 0) `Hspec.shouldSatisfy` Either.isLeft
      test $ f (1 / 0) `Hspec.shouldSatisfy` Either.isLeft
      test $ f (-1 / 0) `Hspec.shouldSatisfy` Either.isLeft

    Hspec.describe "TryCast Float Int32" $ do
      let f = Witch.tryCast @Float @Int.Int32
      test $ f 0 `Hspec.shouldBe` Right 0
      test $ f 16777215 `Hspec.shouldBe` Right 16777215
      test $ f 16777216 `Hspec.shouldSatisfy` Either.isLeft
      test $ f (-16777215) `Hspec.shouldBe` Right (-16777215)
      test $ f (-16777216) `Hspec.shouldSatisfy` Either.isLeft
      test $ f (0 / 0) `Hspec.shouldSatisfy` Either.isLeft
      test $ f (1 / 0) `Hspec.shouldSatisfy` Either.isLeft
      test $ f (-1 / 0) `Hspec.shouldSatisfy` Either.isLeft

    Hspec.describe "TryCast Float Int64" $ do
      let f = Witch.tryCast @Float @Int.Int64
      test $ f 0 `Hspec.shouldBe` Right 0
      test $ f 16777215 `Hspec.shouldBe` Right 16777215
      test $ f 16777216 `Hspec.shouldSatisfy` Either.isLeft
      test $ f (-16777215) `Hspec.shouldBe` Right (-16777215)
      test $ f (-16777216) `Hspec.shouldSatisfy` Either.isLeft
      test $ f (0 / 0) `Hspec.shouldSatisfy` Either.isLeft
      test $ f (1 / 0) `Hspec.shouldSatisfy` Either.isLeft
      test $ f (-1 / 0) `Hspec.shouldSatisfy` Either.isLeft

    Hspec.describe "TryCast Float Int" $ do
      let f = Witch.tryCast @Float @Int
      test $ f 0 `Hspec.shouldBe` Right 0
      test $ f 16777215 `Hspec.shouldBe` Right 16777215
      test $ f 16777216 `Hspec.shouldSatisfy` Either.isLeft
      test $ f (-16777215) `Hspec.shouldBe` Right (-16777215)
      test $ f (-16777216) `Hspec.shouldSatisfy` Either.isLeft
      test $ f (0 / 0) `Hspec.shouldSatisfy` Either.isLeft
      test $ f (1 / 0) `Hspec.shouldSatisfy` Either.isLeft
      test $ f (-1 / 0) `Hspec.shouldSatisfy` Either.isLeft

    Hspec.describe "TryCast Float Integer" $ do
      let f = Witch.tryCast @Float @Integer
      test $ f 0 `Hspec.shouldBe` Right 0
      test $ f 16777215 `Hspec.shouldBe` Right 16777215
      test $ f 16777216 `Hspec.shouldSatisfy` Either.isLeft
      test $ f (-16777215) `Hspec.shouldBe` Right (-16777215)
      test $ f (-16777216) `Hspec.shouldSatisfy` Either.isLeft
      test $ f (0 / 0) `Hspec.shouldSatisfy` Either.isLeft
      test $ f (1 / 0) `Hspec.shouldSatisfy` Either.isLeft
      test $ f (-1 / 0) `Hspec.shouldSatisfy` Either.isLeft

    Hspec.describe "TryCast Float Word8" $ do
      let f = Witch.tryCast @Float @Word.Word8
      test $ f 0 `Hspec.shouldBe` Right 0
      test $ f 255 `Hspec.shouldBe` Right 255
      test $ f 256 `Hspec.shouldSatisfy` Either.isLeft
      test $ f (0 / 0) `Hspec.shouldSatisfy` Either.isLeft
      test $ f (1 / 0) `Hspec.shouldSatisfy` Either.isLeft
      test $ f (-1 / 0) `Hspec.shouldSatisfy` Either.isLeft

    Hspec.describe "TryCast Float Word16" $ do
      let f = Witch.tryCast @Float @Word.Word16
      test $ f 0 `Hspec.shouldBe` Right 0
      test $ f 65535 `Hspec.shouldBe` Right 65535
      test $ f 65536 `Hspec.shouldSatisfy` Either.isLeft
      test $ f (0 / 0) `Hspec.shouldSatisfy` Either.isLeft
      test $ f (1 / 0) `Hspec.shouldSatisfy` Either.isLeft
      test $ f (-1 / 0) `Hspec.shouldSatisfy` Either.isLeft

    Hspec.describe "TryCast Float Word32" $ do
      let f = Witch.tryCast @Float @Word.Word32
      test $ f 0 `Hspec.shouldBe` Right 0
      test $ f 16777215 `Hspec.shouldBe` Right 16777215
      test $ f 16777216 `Hspec.shouldSatisfy` Either.isLeft
      test $ f (0 / 0) `Hspec.shouldSatisfy` Either.isLeft
      test $ f (1 / 0) `Hspec.shouldSatisfy` Either.isLeft
      test $ f (-1 / 0) `Hspec.shouldSatisfy` Either.isLeft

    Hspec.describe "TryCast Float Word64" $ do
      let f = Witch.tryCast @Float @Word.Word64
      test $ f 0 `Hspec.shouldBe` Right 0
      test $ f 16777215 `Hspec.shouldBe` Right 16777215
      test $ f 16777216 `Hspec.shouldSatisfy` Either.isLeft
      test $ f (0 / 0) `Hspec.shouldSatisfy` Either.isLeft
      test $ f (1 / 0) `Hspec.shouldSatisfy` Either.isLeft
      test $ f (-1 / 0) `Hspec.shouldSatisfy` Either.isLeft

    Hspec.describe "TryCast Float Word" $ do
      let f = Witch.tryCast @Float @Word
      test $ f 0 `Hspec.shouldBe` Right 0
      test $ f 16777215 `Hspec.shouldBe` Right 16777215
      test $ f 16777216 `Hspec.shouldSatisfy` Either.isLeft
      test $ f (0 / 0) `Hspec.shouldSatisfy` Either.isLeft
      test $ f (1 / 0) `Hspec.shouldSatisfy` Either.isLeft
      test $ f (-1 / 0) `Hspec.shouldSatisfy` Either.isLeft

    Hspec.describe "TryCast Float Natural" $ do
      let f = Witch.tryCast @Float @Natural.Natural
      test $ f 0 `Hspec.shouldBe` Right 0
      test $ f 16777215 `Hspec.shouldBe` Right 16777215
      test $ f 16777216 `Hspec.shouldSatisfy` Either.isLeft
      test $ f (0 / 0) `Hspec.shouldSatisfy` Either.isLeft
      test $ f (1 / 0) `Hspec.shouldSatisfy` Either.isLeft
      test $ f (-1 / 0) `Hspec.shouldSatisfy` Either.isLeft

    Hspec.describe "TryCast Float Rational" $ do
      let f = Witch.tryCast @Float @Rational
      test $ f 0 `Hspec.shouldBe` Right 0
      test $ f (-0) `Hspec.shouldBe` Right 0
      test $ f 0.5 `Hspec.shouldBe` Right 0.5
      test $ f (-0.5) `Hspec.shouldBe` Right (-0.5)
      test $ f 16777215 `Hspec.shouldBe` Right 16777215
      test $ f (-16777215) `Hspec.shouldBe` Right (-16777215)
      test $ f 16777216 `Hspec.shouldBe` Right 16777216
      test $ f (-16777216) `Hspec.shouldBe` Right (-16777216)
      test $ f (0 / 0) `Hspec.shouldSatisfy` Either.isLeft
      test $ f (1 / 0) `Hspec.shouldSatisfy` Either.isLeft
      test $ f (-1 / 0) `Hspec.shouldSatisfy` Either.isLeft

    Hspec.describe "Cast Float Double" $ do
      let f = Witch.cast @Float @Double
      test $ f 0 `Hspec.shouldBe` 0
      test $ f 0.5 `Hspec.shouldBe` 0.5
      test $ f (-0.5) `Hspec.shouldBe` (-0.5)

    -- Double

    Hspec.describe "TryCast Double Int8" $ do
      let f = Witch.tryCast @Double @Int.Int8
      test $ f 0 `Hspec.shouldBe` Right 0
      test $ f 127 `Hspec.shouldBe` Right 127
      test $ f 128 `Hspec.shouldSatisfy` Either.isLeft
      test $ f (-128) `Hspec.shouldBe` Right (-128)
      test $ f (-129) `Hspec.shouldSatisfy` Either.isLeft
      test $ f (0 / 0) `Hspec.shouldSatisfy` Either.isLeft
      test $ f (1 / 0) `Hspec.shouldSatisfy` Either.isLeft
      test $ f (-1 / 0) `Hspec.shouldSatisfy` Either.isLeft

    Hspec.describe "TryCast Double Int16" $ do
      let f = Witch.tryCast @Double @Int.Int16
      test $ f 0 `Hspec.shouldBe` Right 0
      test $ f 32767 `Hspec.shouldBe` Right 32767
      test $ f 32768 `Hspec.shouldSatisfy` Either.isLeft
      test $ f (-32768) `Hspec.shouldBe` Right (-32768)
      test $ f (-32769) `Hspec.shouldSatisfy` Either.isLeft
      test $ f (0 / 0) `Hspec.shouldSatisfy` Either.isLeft
      test $ f (1 / 0) `Hspec.shouldSatisfy` Either.isLeft
      test $ f (-1 / 0) `Hspec.shouldSatisfy` Either.isLeft

    Hspec.describe "TryCast Double Int32" $ do
      let f = Witch.tryCast @Double @Int.Int32
      test $ f 0 `Hspec.shouldBe` Right 0
      test $ f 2147483647 `Hspec.shouldBe` Right 2147483647
      test $ f 2147483648 `Hspec.shouldSatisfy` Either.isLeft
      test $ f (-2147483648) `Hspec.shouldBe` Right (-2147483648)
      test $ f (-2147483649) `Hspec.shouldSatisfy` Either.isLeft
      test $ f (0 / 0) `Hspec.shouldSatisfy` Either.isLeft
      test $ f (1 / 0) `Hspec.shouldSatisfy` Either.isLeft
      test $ f (-1 / 0) `Hspec.shouldSatisfy` Either.isLeft

    Hspec.describe "TryCast Double Int64" $ do
      let f = Witch.tryCast @Double @Int.Int64
      test $ f 0 `Hspec.shouldBe` Right 0
      test $ f 9007199254740991 `Hspec.shouldBe` Right 9007199254740991
      test $ f 9007199254740992 `Hspec.shouldSatisfy` Either.isLeft
      test $ f (-9007199254740991) `Hspec.shouldBe` Right (-9007199254740991)
      test $ f (-9007199254740992) `Hspec.shouldSatisfy` Either.isLeft
      test $ f (0 / 0) `Hspec.shouldSatisfy` Either.isLeft
      test $ f (1 / 0) `Hspec.shouldSatisfy` Either.isLeft
      test $ f (-1 / 0) `Hspec.shouldSatisfy` Either.isLeft

    Hspec.describe "TryCast Double Int" $ do
      Monad.when (toInteger (maxBound :: Int) < 9007199254740991) untested
      let f = Witch.tryCast @Double @Int
      test $ f 0 `Hspec.shouldBe` Right 0
      test $ f 9007199254740991 `Hspec.shouldBe` Right 9007199254740991
      test $ f 9007199254740992 `Hspec.shouldSatisfy` Either.isLeft
      test $ f (-9007199254740991) `Hspec.shouldBe` Right (-9007199254740991)
      test $ f (-9007199254740992) `Hspec.shouldSatisfy` Either.isLeft
      test $ f (0 / 0) `Hspec.shouldSatisfy` Either.isLeft
      test $ f (1 / 0) `Hspec.shouldSatisfy` Either.isLeft
      test $ f (-1 / 0) `Hspec.shouldSatisfy` Either.isLeft

    Hspec.describe "TryCast Double Integer" $ do
      let f = Witch.tryCast @Double @Integer
      test $ f 0 `Hspec.shouldBe` Right 0
      test $ f 9007199254740991 `Hspec.shouldBe` Right 9007199254740991
      test $ f 9007199254740992 `Hspec.shouldSatisfy` Either.isLeft
      test $ f (-9007199254740991) `Hspec.shouldBe` Right (-9007199254740991)
      test $ f (-9007199254740992) `Hspec.shouldSatisfy` Either.isLeft
      test $ f (0 / 0) `Hspec.shouldSatisfy` Either.isLeft
      test $ f (1 / 0) `Hspec.shouldSatisfy` Either.isLeft
      test $ f (-1 / 0) `Hspec.shouldSatisfy` Either.isLeft

    Hspec.describe "TryCast Double Word8" $ do
      let f = Witch.tryCast @Double @Word.Word8
      test $ f 0 `Hspec.shouldBe` Right 0
      test $ f 255 `Hspec.shouldBe` Right 255
      test $ f 256 `Hspec.shouldSatisfy` Either.isLeft
      test $ f (0 / 0) `Hspec.shouldSatisfy` Either.isLeft
      test $ f (1 / 0) `Hspec.shouldSatisfy` Either.isLeft
      test $ f (-1 / 0) `Hspec.shouldSatisfy` Either.isLeft

    Hspec.describe "TryCast Double Word16" $ do
      let f = Witch.tryCast @Double @Word.Word16
      test $ f 0 `Hspec.shouldBe` Right 0
      test $ f 65535 `Hspec.shouldBe` Right 65535
      test $ f 65536 `Hspec.shouldSatisfy` Either.isLeft
      test $ f (0 / 0) `Hspec.shouldSatisfy` Either.isLeft
      test $ f (1 / 0) `Hspec.shouldSatisfy` Either.isLeft
      test $ f (-1 / 0) `Hspec.shouldSatisfy` Either.isLeft

    Hspec.describe "TryCast Double Word32" $ do
      let f = Witch.tryCast @Double @Word.Word32
      test $ f 0 `Hspec.shouldBe` Right 0
      test $ f 4294967295 `Hspec.shouldBe` Right 4294967295
      test $ f 4294967296 `Hspec.shouldSatisfy` Either.isLeft
      test $ f (0 / 0) `Hspec.shouldSatisfy` Either.isLeft
      test $ f (1 / 0) `Hspec.shouldSatisfy` Either.isLeft
      test $ f (-1 / 0) `Hspec.shouldSatisfy` Either.isLeft

    Hspec.describe "TryCast Double Word64" $ do
      let f = Witch.tryCast @Double @Word.Word64
      test $ f 0 `Hspec.shouldBe` Right 0
      test $ f 9007199254740991 `Hspec.shouldBe` Right 9007199254740991
      test $ f 9007199254740992 `Hspec.shouldSatisfy` Either.isLeft
      test $ f (0 / 0) `Hspec.shouldSatisfy` Either.isLeft
      test $ f (1 / 0) `Hspec.shouldSatisfy` Either.isLeft
      test $ f (-1 / 0) `Hspec.shouldSatisfy` Either.isLeft

    Hspec.describe "TryCast Double Word" $ do
      Monad.when (toInteger (maxBound :: Word) < 9007199254740991) untested
      let f = Witch.tryCast @Double @Word
      test $ f 0 `Hspec.shouldBe` Right 0
      test $ f 9007199254740991 `Hspec.shouldBe` Right 9007199254740991
      test $ f 9007199254740992 `Hspec.shouldSatisfy` Either.isLeft
      test $ f (0 / 0) `Hspec.shouldSatisfy` Either.isLeft
      test $ f (1 / 0) `Hspec.shouldSatisfy` Either.isLeft
      test $ f (-1 / 0) `Hspec.shouldSatisfy` Either.isLeft

    Hspec.describe "TryCast Double Natural" $ do
      let f = Witch.tryCast @Double @Natural.Natural
      test $ f 0 `Hspec.shouldBe` Right 0
      test $ f 9007199254740991 `Hspec.shouldBe` Right 9007199254740991
      test $ f 9007199254740992 `Hspec.shouldSatisfy` Either.isLeft
      test $ f (0 / 0) `Hspec.shouldSatisfy` Either.isLeft
      test $ f (1 / 0) `Hspec.shouldSatisfy` Either.isLeft
      test $ f (-1 / 0) `Hspec.shouldSatisfy` Either.isLeft

    Hspec.describe "TryCast Double Rational" $ do
      let f = Witch.tryCast @Double @Rational
      test $ f 0 `Hspec.shouldBe` Right 0
      test $ f (-0) `Hspec.shouldBe` Right 0
      test $ f 0.5 `Hspec.shouldBe` Right 0.5
      test $ f (-0.5) `Hspec.shouldBe` Right (-0.5)
      test $ f 9007199254740991 `Hspec.shouldBe` Right 9007199254740991
      test $ f (-9007199254740991) `Hspec.shouldBe` Right (-9007199254740991)
      test $ f 9007199254740992 `Hspec.shouldBe` Right 9007199254740992
      test $ f (-9007199254740992) `Hspec.shouldBe` Right (-9007199254740992)
      test $ f (0 / 0) `Hspec.shouldSatisfy` Either.isLeft
      test $ f (1 / 0) `Hspec.shouldSatisfy` Either.isLeft
      test $ f (-1 / 0) `Hspec.shouldSatisfy` Either.isLeft

    -- NonEmpty

    Hspec.describe "TryCast [a] (NonEmpty a)" $ do
      let f = Witch.tryCast @[Int] @(NonEmpty.NonEmpty Int)
      test $ f [] `Hspec.shouldSatisfy` Either.isLeft
      test $ f [1] `Hspec.shouldBe` Right (1 NonEmpty.:| [])
      test $ f [1, 2] `Hspec.shouldBe` Right (1 NonEmpty.:| [2])

    Hspec.describe "Cast (NonEmpty a) [a]" $ do
      let f = Witch.cast @(NonEmpty.NonEmpty Int) @[Int]
      test $ f (1 NonEmpty.:| []) `Hspec.shouldBe` [1]
      test $ f (1 NonEmpty.:| [2]) `Hspec.shouldBe` [1, 2]

    -- Ratio

    Hspec.describe "Cast a (Ratio a)" $ do
      test $ Witch.cast @Integer @Rational 0 `Hspec.shouldBe` 0
      let f = Witch.cast @Int @(Ratio.Ratio Int)
      test $ f 0 `Hspec.shouldBe` 0

    Hspec.describe "TryCast (Ratio a) a" $ do
      test $ Witch.tryCast @Rational @Integer 0 `Hspec.shouldBe` Right 0
      test $ Witch.tryCast @Rational @Integer 0.5 `Hspec.shouldSatisfy` Either.isLeft
      let f = Witch.tryCast @(Ratio.Ratio Int) @Int
      test $ f 0 `Hspec.shouldBe` Right 0
      test $ f 0.5 `Hspec.shouldSatisfy` Either.isLeft

    -- Fixed

    Hspec.describe "Cast Integer (Fixed a)" $ do
      test $ Witch.cast @Integer @Fixed.Uni 1 `Hspec.shouldBe` 1
      let f = Witch.cast @Integer @Fixed.Deci
      test $ f 1 `Hspec.shouldBe` 0.1

    Hspec.describe "Cast (Fixed a) Integer" $ do
      test $ Witch.cast @Fixed.Uni @Integer 1 `Hspec.shouldBe` 1
      let f = Witch.cast @Fixed.Deci @Integer
      test $ f 1 `Hspec.shouldBe` 10

    -- Complex

    Hspec.describe "Cast a (Complex a)" $ do
      test $ Witch.cast @Double @(Complex.Complex Double) 1 `Hspec.shouldBe` 1
      let f = Witch.cast @Float @(Complex.Complex Float)
      test $ f 1 `Hspec.shouldBe` 1

    Hspec.describe "TryCast (Complex a) a" $ do
      test $ Witch.tryCast @(Complex.Complex Double) @Double 1 `Hspec.shouldBe` Right 1
      test $ Witch.tryCast @(Complex.Complex Double) @Double (0 Complex.:+ 1) `Hspec.shouldSatisfy` Either.isLeft
      let f = Witch.tryCast @(Complex.Complex Float) @Float
      test $ f 1 `Hspec.shouldBe` Right 1
      test $ f (0 Complex.:+ 1) `Hspec.shouldSatisfy` Either.isLeft

test :: Hspec.Example a => a -> Hspec.SpecWith (Hspec.Arg a)
test = Hspec.it ""

untested :: Hspec.SpecWith a
untested = Hspec.runIO $ Exception.throwIO Untested

data Untested
  = Untested
  deriving (Eq, Show)

instance Exception.Exception Untested

newtype Name
  = Name String
  deriving (Eq, Show)

instance Witch.Cast Name String

instance Witch.Cast String Name
