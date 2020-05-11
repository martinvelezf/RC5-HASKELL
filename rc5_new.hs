


import Data.Char
import Data.Bits as B




convertListOfInt s =map (fromEnum) s 
convertListofChar s=map (\x ->toEnum x::Char) s

fillwithspaces x size=x ++ (replicate size ' ')

covertToInt x1 x2 
    |a1>a2 = (convertListOfInt x1) `zip` (convertListOfInt (fillwithspaces x2 (a1-a2))) 
    |a1<a2 = (convertListOfInt (fillwithspaces x1 (a2-a1))) `zip` (convertListOfInt x2 )    
    |a1==a2 = (convertListOfInt x1) `zip` (convertListOfInt x2 )
    where
    a1=length x1
    a2=length x2
    
        --in x=convertListOfInt x1 `zip` convertListOfInt x2

covertToString x= r
    where 
        a=(unzip x)
        r=((convertListofChar $fst a),(convertListofChar $snd a))
        
         




encrypt ab s r= x 
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



decrypt  ab s r = x
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

--esta funcion no la usamos jajaja
covertToInts s= r where
    p=convertListOfInt s
    t=length p
    l=[0..(t-1)]
    e=map (1000^) l
    r=foldl (\c (x,y) -> x*y+c) 0 $zip p e



s pw qw size= skey where 
            a=[pw] ++ replicate (size-1) 0
            skey=scanl1 (\x y->qw+x+y) a 
--z=[1..size]
--c=map (truncate.(/u)) z
--[a!!j<<<8+k!!i| j<-c && i<- ]





