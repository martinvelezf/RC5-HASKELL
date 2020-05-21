module RC5 where
import Key
import EncDec as E
import Data.List.Split
import  Data.Text.Read 
import qualified Data.Text as T
convertListOfInt :: Enum a => [a] -> [Int]
convertListOfInt s =map (fromEnum) s 

convertListofChar :: [Int] -> [Char]
convertListofChar s=map (\x ->toEnum x::Char) s

fillwithspaces :: [Char] -> Int -> [Char]
fillwithspaces x size=x ++ (replicate size ' ')

covertToInt :: [Char] -> [Char] -> [(Int, Int)]
covertToInt x1 x2 
    |a1>a2 = (convertListOfInt x1) `zip` (convertListOfInt (fillwithspaces x2 (a1-a2))) 
    |a1<a2 = (convertListOfInt (fillwithspaces x1 (a2-a1))) `zip` (convertListOfInt x2 )    
    |a1==a2 = (convertListOfInt x1) `zip` (convertListOfInt x2 )
    where
    a1=length x1
    a2=length x2
    
convertToString :: [(Int, Int)] -> ([Char], [Char])
convertToString x= r
    where 
        a=(unzip x)
        r=((convertListofChar $fst a),(convertListofChar $snd a))

encryption :: [Char] -> [Char] -> Int -> [(Int, Int)]
encryption s1 s2 r= x where
    ab=covertToInt s1 s2
    s=Key.createSecretKey Key.Word8 [1..100] r
    x=map (E.encrypt s r) ab 

decryption :: [(Int, Int)] -> Int -> ([Char], [Char])    
decryption x r= y where
    s=Key.createSecretKey Key.Word8 [1..100] r
    txt=map (E.decrypt s r) x
    y=convertToString txt

convertencryptxt x= (p,q) where
	y=unzip x	
	p= T.pack $ init $concat $map (\x->(show x)++['x']) (fst y)
	q=T.pack $ init $concat $map (\x->(show x)++['x']) (snd y)

texttodecrypt p q=(x,y) where
	x=map (\x->read x::Int) $splitOn "x" (T.unpack p)
	y=map (\x->read x::Int) $splitOn "x" (T.unpack q)
-------------------------------Correr en consola--------------------------------
--x=encryption "sda" "sdd8" 4
-- decryption x 4 
--x=encryption "matinvelez" "sdd8" 10
--decryption x 10
