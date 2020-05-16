module Key where
import Data.Bits as B

data Count= Count Int Int Int Int deriving Show
setCount::Int->Int->Int->Int->Count
setCount =Count 

--data Word=Word8 8 | Word16 16 | Word32 32 | Word64 64 deriving (Read,Show,Eq)
--data Word= Word 8 |  16 |  32 | 64 
data Word=Word8 | Word16  | Word32  | Word64  deriving (Read,Show,Eq)

w :: Key.Word->Int
w word=case word of 
    Key.Word8->8
    Key.Word16->16
    Key.Word32->32
    Key.Word64->64

odd' :: Integral a => a -> a
odd' x 
    |odd x= x
    |otherwise =x+1


changevalue :: [a] -> Int -> a -> [a]
changevalue a pos v= x where
    div=splitAt' pos a
    x=fst div ++ [v] ++ snd div


splitAt' :: Int -> [a] -> ([a], [a])
splitAt' n xs 
            | (n>0) = (take (n-1) xs, drop n xs)
            | (n==0) =([], drop (n+1) xs)


-------------------------------------------------------------RC5------------------------------------------------------
magicC :: (Integral a, Integral a1) => Key.Word -> (a1, a)
magicC word= x where
    pw= odd' $truncate $((exp 1)-2)*(2^(w word))
    qw= odd' $truncate $(1.61803398875-1)*(2^(w word))
    x=(pw,qw)

bitsToWords:: (Num a, Real t, Bits a) => Rational -> ([a], t) -> a -> ([a], t)
bitsToWords u (l,i) s= x where
    pos=truncate  (toRational i/  u) 
    v=l!!pos
    nv=  v `B.rotateL` 8 +s
    l'=changevalue l pos nv
    x=(l',i-1)

lbitsToWords :: (Num a, Real t, Bits a) => [a] -> t -> Rational -> Int -> [a]
lbitsToWords k b u c= x where
    key=reverse k
    l=replicate (c) 0
    g=bitsToWords  u
    x=fst $foldl g (l, b-1) key


 
initializateS :: Num t => t -> t -> Int -> [t]
initializateS pw qw size= skey where 
            a=[pw] ++ replicate (size-1) 0
            skey=scanl1 (\x y->qw+x+y) a 





fsmixed ::Int->Int -> (Count, ([Int],[Int])) -> (Count, ([Int],[Int]))
fsmixed t c (Count a b i j,(l,s))= x where     
        a'=(s!!i+(a+b)) `B.rotateL` 3
        b'=(l!!j+(a'+b)) `B.rotateL` (a'+b)
        s'=changevalue s i a'
        l'=changevalue l j b'
        i'=(i+1)`mod` t
        j'=(j+1)`mod` c
        x=(setCount a' b' i' j',(l',s'))


smixed :: [Int] -> [Int] -> Int -> Int -> [Int]
smixed l s t c=  snd $snd $iterate (fsmixed t c) (Count 0 0 0 0 ,(l,s))!! (3*max t c)

createSecretKey :: Key.Word -> [Int] -> Int -> [Int]
createSecretKey word k r=x where
    (pw,qw)=magicC  word
    wo=(w word)
    u=(toRational wo/8)
    b=length k 
    c=truncate  (toRational b/u)
    
    l=lbitsToWords  k b u c
    t=2*(r+1)
    s=initializateS pw qw t
    x=smixed l s t c
