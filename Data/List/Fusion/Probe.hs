{- |
   Copyright  : Copyright (C) 2014 Joachim Breitner
   License    : BSD3

   Maintainer : Joachim Breitner <mail@joachim-breitner.de>
   Stability  : stable
   Portability: GHCspecific
-}

module Data.List.Fusion.Probe where


import GHC.Exts (build, augment)

-- | This function can be wrapped around a list that should be compiled away by
-- list fusion. If it does, this function will disappear. If not, it will throw
-- an error at runtime.
--
-- > main = print $ foldl (+) 0 (fuseThis [0..1000])
--
-- Will print @Test: fuseList: List did not fuse@, while
--
-- > main = print $ foldr (+) 0 (fuseThis [0..1000])
--
-- will print @500500@.

fuseThis :: [a] -> [a]
fuseThis = id

{-# NOINLINE fuseThis #-}

{-# RULES
"fold/fuseThis/build" [~0]
    forall k z (g::forall b. (a->b->b) -> b -> b) .
    foldr k z (fuseThis (build g)) = g k z

"foldr/fuseThis/augment" [~0]
    forall k z xs (g::forall b. (a->b->b) -> b -> b) .
    foldr k z (fuseThis (augment g xs)) = g k (foldr k z xs)
 #-}

{-# RULES
"fuseThis/fail" [0]
    fuseThis = error "fuseThis: List did not fuse"
 #-}

