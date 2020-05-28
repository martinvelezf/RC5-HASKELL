import Data.Bits
import Data.Time

main=do print test

test = [y | let s=secretkey [1..4] 100,
	   let x=encrp [0,0] s 100,
		y<- desencrypt x s 100 100]


encryption::[Int]->Int

enc::[Int]->[Int]->Int->[Int]
enc a s i=[ans|
		let x=a!!0,
	    let y=a!!1,
		let m=s!!(i*2),
		let m1=s!!((i*2)+1),
		let w =(rotateL (xor x y) y)+m,
		let z= (rotateL (xor y w) w)+m1,
		ans<-[w]++[z]
        ]

enc::[Int]->[Int]->Int->[Int]
enc a s i=[ans|
		let x=a!!0,
	    	let y=a!!1,
		let m=s!!(i*2),
		let m1=s!!((i*2)+1),
		let w =(rotateL (xor x y) y)+m,
		let z= (rotateL (xor y w) w)+m1,
		ans<-[w]++[z]
        ]

encrp::[Int]->[Int]->Int->[Int]
encrp a s r=[y|let x=[a!!0+s!!0]++[a!!1+s!!1],y<-sencrypt  x s 1 r]

encrypt::[Int]->Int->[Int]
encrypt a r=[y|let s= secretkey [1..4] r,let x=[a!!0+s!!0]++[a!!1+s!!1],y<-sencrypt  x s 1 r]




sencrypt::[Int]->[Int]->Int->Int->[Int]
sencrypt a s i r
	|r==i =(enc a s i)
	|otherwise = sencrypt (enc a s i) s (i+1) r



dep::[Int]->[Int]->Int->[Int]
dep a s i=
	let x=xor (rotateR ((a!!1)-(s!!((2*i)+1))) (a!!0)) (a!!0)
	    y=xor (rotateR ((a!!0)-(s!!(2*i))) (x)) x
	in [y]++[x]

desencrypt::[Int]->[Int]->Int->Int->[Int]
desencrypt a s i r
	|i==1 =[y|let w=dep a s i,let x=[w!!0-s!!0]++[w!!1-s!!1],y<-x]
	|otherwise = desencrypt (dep a s i) s (i-1) r

decrypt::[Int]->Int->[Int]
decrypt a r =desencrypt a (secretkey [1..4] r) r r



sk::Int->[Int]
sk r= sks [3084996963] 1 r
sks::[Int]->Int->Int->[Int]
sks  s i r
	|i==2*(r+1) = s
	|otherwise = [f|let b=s!!(i-1),let y=b+2654435769, let a=s++[y], f<-sks a (i+1) r]

l::[Int]->Int
l k= lei k 0 3

lei::[Int]->Int->Int->Int
lei k l i
	|i== -1 = l
	|otherwise = lei k (shiftL l 8 + k!!i)(i-1)

ksecret::[Int]->[Int]->Int->Int->Int->Int->Int->Int->[Int]
ksecret s se l i a b k r
	|k==2*(r+1) = se
	|otherwise = [f|let t=2*(r+1),let x=rotateL (s!!((i+1)`mod`t)+a+b) 3,let w=rotateL (l+x+b) (x+b), f<-ksecret s (se++[x]) w (i+1) x w (k+1) r]


secretkey::[Int]->Int->[Int]
secretkey k r= ksecret (sk r) [] (l k) 0 0 0 0 r
