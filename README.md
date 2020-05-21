# RC5-HASKELL
Welcome to our RC5-Haskell repository. This project was develop for our Functional Programming class at [Yachay Tech](https://www.yachaytech.edu.ec/). Please be aware that the code was develop for a class project and is not 100% secure for use at a production environment.

## Description
This project is aim to build a simple company login system using the RC5 encryption for authentication and a web server for the application itself. All new libraries added should be included in the *application.cabal* file. In order to test the code in your computer remember to run:
```bash
git clone https://github.com/martinvelezf/RC5-HASKELL.git
cabal install --only-dependencies
ghcid -T :main
```
Go to [http://localhost:8080/](http://localhost:8080/) in any browser in your computer to use the application

For the momment use these credentials to login:
+  email: nicolas.serrano@yachaytech.edu.ec
+  password: encryptedpassword

## Architecture
### Encryption
*Martin Velez*

This code is based in the Rivest implementation of 1995 in Haskell. The original paper can be found [here](/references/ivest1995_Chapter_TheRC5EncryptionAlgorithm.pdf).

To run the code:
1. Go to the module location: ```cd scr/modules/RC5 ```
2. Start the interpreter: ```ghci RC5.hs ```
3. To encrypt: ```x = encryption "mar" "123" 10 [1..100]```
4. You should get the result as: ```[(-7273264081479612925,-3122923407712225928),(-625
[(-7273264081479612925,-3122923407712225928),(-6256778535516941383,-1835156827000292027),(4196303171515540263,9185718333346717671)] ```
5. The result has type: ``` List[(Int, Int)] ```
6. To decrypt: ``` decrypt x 10 [1..100]```

In case of get an encryption a decryption in Text, use the following functions:
1. To encrypt: ```x =readytoencrypt "word1" "word2"
```Expected output:>>x ("1225641636062539505x151454429113874280x-3651162783678895878x2720116480418127085x-7618532865284291349","8837152007312300700x-8727207976567962814x-4677416727520607510x5575231667255447601x6768283349087288632")```
2. To dencrypt: ```readytodecrypt (fst x) (snd x)
```Expected output:("word1","word2")```


### Frontend
*Nicolas Serrano*

The application frontend is based on a web server application designed with the [Spock Framework](https://www.spock.li/). The architecture has the following distribution:
![Frontend-Architecture](/references/frontend_architecture.png)

The frontend would use the following data types:
1. User
  1. First name
  1. Last name
  1. Email
  1. Birthday
  1. Password
  1. Occupation
1. ServerState
  1. UserList
1. Server
  1. The web server


### Data Manipulation
*Carlos Munoz*
## Contact
If you have a question, comment or improvement; please feel free to reach out by posting an issue.
