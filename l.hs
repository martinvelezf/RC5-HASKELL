
import Data.Function
import Data.Bits
splitAt' n xs = (take (n-1) xs, drop n xs)

changevalue a pos v= x where
    div=splitAt' pos a
    x=fst div ++ [v] ++ snd div

--f :: (Num a, Integer t) => t -> ([a], t) -> a -> ([a], t)
f u (l,i) s= x where
    pos=truncate  (toRational i/  u) 
    v=l!!pos
    nv= rotateL v 8 +s
    newl=changevalue l pos nv
    x=(newl,i-1)
    
--larray :: (Num a, RealFrac t) => [a] -> Int -> ([a], t)

larray k u = x where
    b=length k 
    key=reverse k
    c=truncate  (toRational b/u)
    l=replicate c 0
    g=f  u
    x=fst $foldl g (l, b-1) key
    --x=([],6)
data Count= Count Int Int Int Int deriving Show
setCount::Int->Int->Int->Int->Count
setCount =Count 


fsmixed ::Int->Int -> (Count, ([Int],[Int])) -> (Count, ([Int],[Int]))
fsmixed t c (Count a b i j,(l,s))= x where     
        a'=s!!i+(a+b)
        b'=l!!j+(a'+b)
        s'=changevalue s i a'
        l'=changevalue l j b'
        i'=(i+1)`mod` t
        j'=(j+1)`mod` c
        x=(setCount a' b' i' j',(l',s'))

l=[1..5]
s=[1..100]
a=Count 0 0 0 0 


smixed l s t c=  snd $snd $iterate (fsmixed t c) (Count 0 0 0 0 ,(l,s))!! (3*max t c)

