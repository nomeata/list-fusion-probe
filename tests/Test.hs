import Data.List.Fusion.Probe

import Test.Tasty
import Test.Tasty.HUnit


import Control.Exception
import Control.Monad

assertErrorCall :: String -> IO a -> IO ()
assertErrorCall ex action =
    handleJust isWanted (const $ return ()) $ do
        action
        assertFailure $ "Expected exception: " ++ show ex
  where isWanted (ErrorCall x) = guard $ x == ex


x1, x2 :: Integer
x1 = foldl (+) 0 (fuseThis [0..1001])
x2 = foldr (+) 0 (fuseThis [0..1000])

main = defaultMain unitTests

unitTests = testGroup "Unit tests"
  [ testCase "foldr fuses" $
      x2 `compare` 500500 @?= EQ

  , testCase "foldl does not fuse" $
      assertErrorCall "fuseThis: List did not fuse" (evaluate x1)
  ]



