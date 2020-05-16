#include <stdio.h>
//#include <windows.h>
typedef unsigned int WORDD; /* Should be 32-bit = 4 bytes */
#define w 32 /* word size in bits */
#define r 100
#define b 4 /* number of bytes in key */
#define c 1 /* number words in key = ceil(8*b/w)*/
#define t 2*(r+1) /* size of table S = 2*(r+l) words */

WORDD S[t]; /* expanded key table */
WORDD P = 0xb7e15163, Q = 0x9e3779b9; /* magic constants */
/* Rotation operators, x must be unsigned, to get logical right shift*/
#define ROTL(x,y) (((x)<<(y&(w-1))) | ((x)>>(w-(y&(w-1)))))
#define ROTR(x,y) (((x)>>(y&(w-1))) | ((x)<<(w-(y&(w-1)))))

void RC5_ENCRYPT(WORDD *pt, WORDD *ct) /* 2 WDRD input pt/output ct */
{ WORDD i, A=pt[0] +S[0] , B=pt[1] +S[1] ;
for (i=1; i<=r; i++)
{ A = ROTL(A^B,B)+S[2*i] ;
B = ROTL(B^A,A)+S[2*i+1] ;
//printf("\n A=%X  B=%X",A,B);
}
ct[0] = A; ct[1] = B;
}

void RC5_DECRYPT(WORDD *ct, WORDD *pt)
{ WORDD i, B=ct[1], A=ct[0];
for (i=r; i>0; i--)
{ B = ROTR(B-S[2*i+1],A)^A;
A = ROTR(A-S[2*i],B)^B;
//printf("\n A=%X  B=%X",A,B);
}
pt[1] = B-S[1]; 
//printf("\n num2=%X-%x ",B,S[1]);
pt[0]=A-S[0];
//printf("\n num1=%X-%x ",A,S[0]);
}

void RC5_SETUP(unsigned char *K) 
{ WORDD i, j, k, u=w/8, A, B, L[c];

/* Initialize L, then S, then mix key into S */
for (i=b-1,L[c-1]=0; i!=-1; i--) 
{L[i/u] = (L[i/u]<<8)+K[i];
//printf("\n L[%d] %d",i/u,L[i/u]);
}

for (S[0]=P,i=1; i<t; i++) {
	S[i] = S[i-1]+Q;
//printf("\n S[%d]=%X",i,S[i]);
}

for (A=B=i=j=k=0; k<3*t; k++,i=(i+1)%t,j=(j+1)%c) /* 3*t > 3.c */
{ A = S[i] = ROTL(S[i]+(A+B),3);
B = L[j] = ROTL(L[j]+(A+B),(A+B));
//printf("\n S[%d]=%X   L[%d]=%X",i,S[i],j,L[j]);

}
}



void main()
{	

  
WORDD i, j, pt1[2], pt2[2], ct[2];
//scanf("%d %d",&ct[0],&ct[1]);
ct[0]=0;
ct[1]=0;
unsigned char key[b];
pt1[0]=ct[0]; pt1[1]=ct[1];
for (j=0;j<b;j++) 
	key[j] = i;
/* Setup, encrypt, and decrypt */
RC5_SETUP(key);
RC5_ENCRYPT(pt1,ct);
printf("[%d, %d]",ct[0],ct[1]);

RC5_DECRYPT(ct,pt2);
printf("\n plaintext %X %X",pt2[0], pt2[1]);
if (pt1[0]!=pt2[0] || pt1[1]!=pt2[1])
printf ("Decryption Error ! ") ; 


  
 

}




