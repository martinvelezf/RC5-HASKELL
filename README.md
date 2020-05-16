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
