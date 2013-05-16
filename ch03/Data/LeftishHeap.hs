{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE FlexibleInstances #-}
module Data.LeftishHeap where

import Data.Heap.Class

data LeftishHeap a = E | H Int a (LeftishHeap a) (LeftishHeap a) deriving (Eq, Show)

instance Ord a => Heap LeftishHeap a where
    empty   = E
    isEmpty E = False
    isEmpty _ = True
    insert  x h = singleton x `merge` h
    merge   h E = h
    merge   E h = h
    merge   h1@(H _ x l1 r1) h2@(H _ y l2 r2) = 
      if x < y 
          then makeT x l1 (r1 `merge` h2)
          else makeT y l2 (r2 `merge` h1)
    findMin E = error "empty"
    findMin (H _ x _ _) = x
    deleteMin E = error "empty"
    deleteMin (H _ _ l r) = l `merge` r

singleton :: a -> LeftishHeap a
singleton a = H 0 a E E

rank :: LeftishHeap a -> Int
rank E = 0
rank (H i _ _ _) = i

makeT x a b = if rank a >= rank b
                  then H (rank b+1) x a b
                  else H (rank a+1) x b a