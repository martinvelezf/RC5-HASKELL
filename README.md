# RC5-HASKELL
Welcome to our RC5-Haskell repository. This project was develop for our Functional Programming class at [Yachay Tech](https://www.yachaytech.edu.ec/). Please be aware that the code was develop for a class project and is not 100% secure for use at a production environment.

### Encryption
*Martin Velez*

This code is based in the Rivest implementation of 1995 in Haskell. The original paper can be found [here](Rivest1995_Chapter_TheRC5EncryptionAlgorithm.pdf).

## Architecture
### Frontend
*Nicolas Serrano*

The application frontend is based on a web server application designed with the [Spock Framework](https://www.spock.li/). The architecture has the following distribution:
![Frontend-Architecture](/images/frontend_architecture.png)

The frontend would use the following data types:
1. Window
  1. Login
  2. Registration
  3. Registered
  4. Error
  5. Private
  6. Incorrect
2. User
  1. First name
  2. Last name
  3. Email
  4. Birthday
  5. Password
  6. Occupation
3. Input
  1. Button
  2. Selector
  3. Text


### Data Manipulation
*Carlos Munoz*
## Contact
If you have a question, comment or improvement; please feel free to reach out by posting an issue.
