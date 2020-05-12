module EncDec where
import Data.Bits as B
encrypt ::  [Int]-> Int ->(Int, Int)-> (Int, Int)
encrypt s r ab= x 
    where
    a=(fst ab)+s!!0
    b=(snd ab)+s!!1
    evenN=filter even [1..r]
    oddN=filter odd [1..r]
    s1=[s!!i|i<-evenN]
    s2=[s!!i|i<-oddN]
    f1 (a,b) (s2,s1) = x where
        ax=(B.rotateL (B.xor a b) b )+s1
        bx=(B.rotateL (B.xor b ax) ax)+s2
        x=(ax,bx)     
    x=foldl f1 (a,b) (zip s2 s1) 


decrypt ::[Int]-> Int ->(Int, Int)-> (Int, Int)
decrypt  s r ab = x
    where
    evenN=filter even [1..r]
    oddN=filter odd [1..r]
    s1= reverse [s!!i|i<-evenN]
    s2= reverse [s!!i|i<-oddN]
    f2 (a,b) (s2,s1) = x where
        bx=(B.xor (B.rotateR (b-s2) (a)) (a))
        ax=xor (rotateR (a-s1) bx) bx
        x=(ax,bx) 
    y=foldl f2 ab (zip s2 s1)
    
    x=(( fst y) -s!!0,(snd y)-s!!1)

