{-# LANGUAGE RecordWildCards #-}
{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE ExtendedDefaultRules #-}

module Datamng where
--import Data.List.Split
import Data.Text (Text)
import qualified Data.Text as T

data User =
   User { name :: Name,
          email :: Text,
          birthday :: Birthday,
          password :: Text,
          occupation :: Text,
          usertype :: Usertype
        }
        deriving (Show)

data Name=
    Name { firstName :: Text,
           lastName :: Text
         }
         deriving (Show)

data Birthday=
    Birthday { day:: Text,
               month:: Text,
               year:: Text
             }
             deriving (Show)

data Usertype= Customer
             | Employee
             | Administrative
             | Other
             deriving (Show)

--Defining a default user
defaultuser =   User { name=Name{firstName="default",lastName="default"}, email="default", birthday=Birthday{day="1",month="1",year="1"}, password = "default", occupation = "default", usertype = Other}

--Takes a file parsed as string of text and converts it into a list of strings
filetolist:: Text -> [Text]
filetolist file = T.splitOn "\n" file

--Takes a string of csvs  and converts it into a list of strings
csvtolist :: Text -> [Text]
csvtolist csvs = T.splitOn "," csvs


--Takes a list of strings and converts to a User
listtoUser:: [Text]-> User
listtoUser [fName,lName,mail,d,m,y,psswd,occ,usrtp]=User{ name= Name {firstName=fName, lastName=lName},
                                                          email=mail,
                                                          birthday=Birthday {day=d, month=m, year=y},
                                                          password=psswd,
                                                          occupation=occ,
                                                          usertype= case usrtp of
                                                                         "Customer"       -> Customer
                                                                         "Employee"       -> Employee
                                                                         "Administrative" -> Administrative
                                                                         _                -> Other
                                                        }
listtoUser [""]=defaultuser
listtoUser _=defaultuser

--Takes a string of csvs and converts it into a User
csvtoUser :: Text -> User
csvtoUser csvs = listtoUser(csvtolist csvs)

--Takes a file parsed as string and converts to a list of users
filetoUsers:: Text -> [User]
filetoUsers file = Prelude.map csvtoUser (filetolist file)

--Takes a Usertype and returns it as string
getusertype:: Usertype -> Text
getusertype usrtp = case usrtp of
                         Customer -> "Customer"
                         Employee -> "Employee"
                         Administrative -> "Administrative"
                         Other -> "Other"                    

--Takes a Name and retunrs a tuple with the first and last name as strings
getName:: Name -> (Text,Text)
getName nme = (firstName(nme),lastName(nme))

--Takes a Birthday and returns it a csv
getBirthday:: Birthday -> Text
getBirthday btdy = T.intercalate "," [day(btdy),month(btdy),year(btdy)]

--Takes a user and converts into a string of csvs
usertocsv :: User -> Text
usertocsv usr= T.intercalate "," [fst(getName(name(usr))),snd(getName(name(usr))), email(usr), getBirthday(birthday(usr)), password(usr), occupation(usr), getusertype(usertype(usr))]

--Takes a list of csv and returns a string separated by jumps of line
listtofile:: [Text] -> Text
listtofile lst =T.intercalate "\n" lst

--Takes a list of users and return a string to be writeen on file
userstofile :: [User]->Text
userstofile lst = listtofile (Prelude.map usertocsv lst)

--Takes a tuple (email,Password) and list of users and  returns the FIRST user whose email and password coincide
returnprivate:: (Text, Text)-> [User]-> (Bool, User)
returnprivate _ []= (False,defaultuser)
returnprivate (encrypemail,encryppass) (usr:lst) = if ((encrypemail==email(usr)) && (encryppass==password(usr))) 
                                                 then (True, usr) 
                                                 else (returnprivate (encrypemail,encryppass) lst)

