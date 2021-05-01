-- | The Witch package is a library that allows you to confidently convert
-- values between various types. This module exports everything you need to
-- perform conversions or define your own. It is designed to be imported
-- unqualified, so getting started is as easy as:
--
-- >>> import Witch
--
-- In typical usage, you will most likely use 'Witch.Utility.into' for
-- 'Witch.Cast.Cast' instances and 'With.Utility.tryInto' for
-- 'Witch.TryCast.TryCast' instances.
module Witch
  ( -- * Type classes

  -- ** Cast
    Witch.Cast.Cast(cast)
  , Witch.Utility.from
  , Witch.Utility.into

  -- ** TryCast
  , Witch.TryCast.TryCast(tryCast)
  , Witch.Utility.tryFrom
  , Witch.Utility.tryInto

  -- * Utilities
  , Witch.Utility.as
  , Witch.Utility.over
  , Witch.Utility.via
  , Witch.Utility.tryVia
  , Witch.Utility.maybeTryCast
  , Witch.Utility.eitherTryCast

  -- ** Unsafe
  -- | These functions should only be used in two circumstances: When you know
  -- a conversion is safe even though you can't prove it to the compiler, and
  -- when you're alright with your program crashing if the conversion fails.
  -- In all other cases you should prefer the normal conversion functions like
  -- 'Witch.Cast.cast'. And if you're converting a literal value, consider
  -- using the Template Haskell conversion functions like
  -- 'Witch.Lift.liftedCast'.
  , Witch.Utility.unsafeCast
  , Witch.Utility.unsafeFrom
  , Witch.Utility.unsafeInto

  -- ** Template Haskell
  -- | This library uses /typed/ Template Haskell, which may be a little
  -- different than what you're used to. Normally Template Haskell uses the
  -- @$(...)@ syntax for splicing in things to run at compile time. The typed
  -- variant uses the @$$(...)@ syntax for splices, doubling up on the dollar
  -- signs. Other than that, using typed Template Haskell should be pretty
  -- much the same as using regular Template Haskell.
  , Witch.Lift.liftedCast
  , Witch.Lift.liftedFrom
  , Witch.Lift.liftedInto

  -- * Data types
  , Witch.TryCastException.TryCastException(..)

  -- ** Casting
  , Witch.Casting.Casting(Casting)

  -- * Notes

  -- ** Motivation
  -- | Haskell provides many ways to convert between common types, and core
  -- libraries add even more. It can be challenging to know which function to
  -- use when converting from some source type @a@ to some target type @b@. It
  -- can be even harder to know if that conversion is safe or if there are any
  -- pitfalls to watch out for.
  --
  -- This library tries to address that problem by providing a common
  -- interface for converting between types. The 'Witch.Cast.Cast' type class
  -- is for conversions that cannot fail, and the 'Witch.TryCast.TryCast' type
  -- class is for conversions that can fail. These type classes are inspired
  -- by the [@From@](https://doc.rust-lang.org/std/convert/trait.From.html)
  -- trait in Rust.

  -- ** Alternatives
  -- | Many Haskell libraries already provide similar functionality. How is
  -- this library different?
  --
  -- - [@Coercible@](https://hackage.haskell.org/package/base-4.15.0.0/docs/Data-Coerce.html#t:Coercible):
  --   This type class is solved by the compiler, but it only works for types
  --   that have the same runtime representation. This is very convenient for
  --   @newtype@s, but it does not work for converting between arbitrary types
  --   like @Int8@ and @Int16@.
  --
  -- - [@Convertible@](https://hackage.haskell.org/package/convertible-1.1.1.0/docs/Data-Convertible-Base.html#t:Convertible):
  --   This popular conversion type class is similar to what this library
  --   provides. The main difference is that it does not differentiate between
  --   conversions that can fail and those that cannot.
  --
  -- - [@From@](https://hackage.haskell.org/package/basement-0.0.11/docs/Basement-From.html#t:From):
  --   This type class is almost identical to what this library provides.
  --   Unfortunately it is part of the @basement@ package, which is an
  --   alternative standard library that some people may not want to depend
  --   on.
  --
  -- - [@Inj@](https://hackage.haskell.org/package/inj-1.0/docs/Inj.html#t:Inj):
  --   This type class requires instances to be an injection, which means that
  --   no two input values should map to the same output. That restriction
  --   prohibits many useful instances. Also many instances throw impure
  --   exceptions.
  --
  -- In addition to those general-purpose type classes, there are many
  -- alternatives for more specific conversions. How does this library compare
  -- to those?
  --
  -- - Monomorphic conversion functions like [@Data.Text.pack@](https://hackage.haskell.org/package/text-1.2.4.1/docs/Data-Text.html#v:pack)
  --   are explicit but not necessarily convenient. It can be tedious to
  --   manage the imports necessary to use the functions. And if you want to
  --   put them in a custom prelude, you will have to come up with your own
  --   names.
  --
  -- - Polymorphic conversion methods like 'toEnum' are more convenient but
  --   may have unwanted semantics or runtime behavior. For example the 'Enum'
  --   type class is more or less tied to the 'Int' data type and frequently
  --   throws impure exceptions.
  --
  -- - Polymorphic conversion functions like 'fromIntegral' are very
  --   convenient. Unfortunately it can be challenging to know which types
  --   have the instances necessary to make the conversion possible. And even
  --   if the conversion is possible, is it safe? For example converting a
  --   negative 'Int' into a 'Word' will overflow, which may be surprising.

  -- ** Instances
  -- | When should you add a 'Witch.Cast.Cast' (or 'Witch.TryCast.TryCast')
  -- instance for some pair of types? This is a surprisingly tricky question
  -- to answer precisely. Instances are driven more by guidelines than rules.
  --
  -- - Conversions must not throw impure exceptions. This means no 'undefined'
  --   or anything equivalent to it.
  --
  -- - Conversions should be unambiguous. If there are multiple reasonable
  --   ways to convert from @a@ to @b@, then you probably should not add a
  --   @Cast@ instance for them.
  --
  -- - Conversions should be lossless. If you have @Cast a b@ then no two @a@
  --   values should be converted to the same @b@ value.
  --
  -- - If you have both @Cast a b@ and @Cast b a@, then
  --   @cast \@b \@a . cast \@a \@b@ should be the same as 'id'. In other
  --   words, @a@ and @b@ are isomorphic.
  --
  -- - If you have both @Cast a b@ and @Cast b c@, then you could also have
  --   @Cast a c@ and it should be the same as @cast \@b \@c . cast \@a \@b@.
  --   In other words, @Cast@ is transitive.
  --
  -- In general if @s@ is a @t@, then you should add a 'Witch.Cast.Cast'
  -- instance for it. But if @s@ merely can be a @t@, then you could add a
  -- 'Witch.TryCast.TryCast' instance for it. And if it is technically
  -- possible to convert from @s@ to @t@ but there are a lot of caveats, you
  -- probably should not write any instances at all.

  -- ** Type applications
  -- | This library is designed to be used with the [@TypeApplications@](https://downloads.haskell.org/~ghc/9.0.1/docs/html/users_guide/exts/type_applications.html)
  -- language extension. Although it is not required for basic functionality,
  -- it is strongly encouraged. You can use 'Witch.Cast.cast',
  -- 'Witch.TryCast.tryCast', 'Witch.Utility.unsafeCast', and
  -- 'Witch.Lift.liftedCast' without type applications. Everything else
  -- requires a type application.

  -- ** Ambiguous types
  -- | You may see @Identity@ show up in some type signatures. Anywhere you see
  -- @Identity a@, you can mentally replace it with @a@. It is a type family
  -- used to trick GHC into requiring type applications for certain functions.
  -- If you forget to give a type application, you will see an error like
  -- this:
  --
  -- >>> from (1 :: Int8) :: Int16
  -- <interactive>:1:1: error:
  --     * Couldn't match type `Identity s0' with `Int8'
  --         arising from a use of `from'
  --       The type variable `s0' is ambiguous
  --     * In the expression: from (1 :: Int8) :: Int16
  --       In an equation for `it': it = from (1 :: Int8) :: Int16
  --
  -- You can fix the problem by giving a type application:
  --
  -- >>> from @Int8 1 :: Int16
  -- 1
  ) where

import qualified Witch.Cast
import qualified Witch.Casting
import Witch.Instances ()
import qualified Witch.Lift
import qualified Witch.TryCast
import qualified Witch.TryCastException
import qualified Witch.Utility
