{-# LANGUAGE OverloadedStrings #-}

module Main where

import Control.Monad.IO.Class(liftIO)
import Control.Monad(forM_)
import Data.Text (Text)
import qualified Data.Text as Text
import Data.IORef
import Data.Semigroup((<>))
import Web.Spock
import Web.Spock.Config
import Web.Spock.Lucid (lucid)
import Lucid

import Modules.RC5
import Modules.Datamng

import System.IO
import qualified Data.Text.IO as Textio

newtype ServerState = ServerState { users :: IORef [User] }

type Server a = SpockM () () ServerState a

app :: Server ()
app = do
  get root $ do
    lucid $ do
      h1_ "Company Intranet"
      p_ "Only registered users would be able to login"
      a_ [href_ "/create"] "Register"
      br_ []
      a_ [href_ "/login"] "Login"

  get "login" $ do
    lucid $ do
      h1_ "User Login"
      form_ [method_ "post"] $ do
        label_ $ do
          "Email: "
          input_ [name_ "email"]
          br_ []
          br_ []
        label_ $ do
          "Password: "
          input_ [name_ "password", type_ "password"]
          br_ []
          br_ []
        input_ [type_ "submit", value_ "Login"]
      br_ []
      a_ [href_ "/"] "Go back to the Homepage"

  post "login" $ do
    email <- param' "email"
    password <- param' "password"

    users' <- getState >>= (liftIO . readIORef . users)
    let x = readytoencrypt email password
    let authUser = returnprivate x users'
    --let a = snd authUser
    let writeUser = usertocsv (snd authUser)

    if fst authUser
      then lucid $ do
        h1_ "Welcome to the Company Intranet"
        p_ "The registered users are:"
        br_ []
        toHtml(writeUser)
        br_ []
        a_ [href_ "/"] "Go back to the Homepage"
    else
      redirect "/failed"

  get "create" $ do
    lucid $ do
      h1_ "User Creation"
      form_ [method_ "post"] $ do
        label_ $ do
          "First Name: "
          input_ [name_ "firstName"]
          br_ []
          br_ []
        label_ $ do
          "Last Name: "
          input_ [name_ "lastName"]
          br_ []
          br_ []
        label_ $ do
          "Email: "
          input_ [name_ "email"]
          br_ []
          br_ []
        label_ $ do
          "Day: "
          input_ [name_ "day"]
          br_ []
          br_ []
        label_ $ do
          "Month: "
          select_ [name_ "month"] $ do
            option_ [value_ "January"] "January"
            option_ [value_ "Febraury"] "Febraury"
            option_ [value_ "March"] "March"
            option_ [value_ "April"] "April"
            option_ [value_ "May"] "May"
            option_ [value_ "June"] "June"
            option_ [value_ "July"] "July"
            option_ [value_ "August"] "August"
            option_ [value_ "September"] "September"
            option_ [value_ "October"] "October"
            option_ [value_ "November"] "November"
            option_ [value_ "December"] "December"
          br_ []
          br_ []
        label_ $ do
          "Year: "
          input_ [name_ "year"]
          br_ []
          br_ []
        label_ $ do
          "Password: "
          input_ [name_ "password", type_ "password"]
          br_ []
          br_ []
        label_ $ do
          "Occupation: "
          input_ [name_ "occupation"]
          br_ []
          br_ []
        label_ $ do
          "User Type: "
          select_ [name_ "userType"] $ do
            option_ [value_ "Customer"] "Customer"
            option_ [value_ "Employee"] "Employee"
            option_ [value_ "Administrative"] "Administrative"
            option_ [value_ "Other"] "Other"
          br_ []
          br_ []
        input_ [type_ "submit", value_ "Create User"]
      br_ []
      a_ [href_ "/"] "Go back to the Homepage"

  post "create" $ do
    firstName <- param' "firstName"
    lastName <- param' "lastName"
    email <- param' "email"
    day <- param' "day"
    month <- param' "month"
    year <- param' "year"
    password <- param' "password"
    occupation <- param' "occupation"
    userType <- param' "userType"

    let encrypted_email = readytoencrypt email password

    let lista = [firstName,lastName,fst encrypted_email,day,month,year,snd encrypted_email,occupation,userType]
    let usuario = listtoUser lista

    --Save the user in the database NOT WORKING
    users' <- getState >>= (liftIO . readIORef . users)
    let dataout = userstofile( removedefault (users' ++ [usuario]) )
    liftIO $ Textio.writeFile "database.csv" dataout

    --Save the user in the server state
    userList <- users <$> getState
    liftIO $ atomicModifyIORef' userList $ \user ->
      (user <> [listtoUser lista], ())
    lucid $ do
      h1_ "User created"
      br_ []
      a_ [href_ "/"] "Go back to the Homepage"


  get "welcome" $ do
    users' <- getState >>= (liftIO . readIORef . users)
    lucid $ do
      h1_ "Welcome to the Company Intranet"
      p_ "The registered users are:"
      ul_ $ forM_ users' $ \user -> li_ $ do
        toHtml (firstName(name(user)))
        ", "
        toHtml (lastName(name(user)))
        ", "
        toHtml(email user)
        ", "
        toHtml(day(birthday(user)))
        "/"
        toHtml(month(birthday(user)))
        "/"
        toHtml(year(birthday(user)))
        ", "
        toHtml(occupation user)
      br_ []
      a_ [href_ "/"] "Go back to the Homepage"

  get "failed" $ do
    lucid $ do
      h1_ "Authentication Failed"
      p_ "The email and password provided are incorrect"
      br_ []
      a_ [href_ "/"] "Go back to the Homepage"


main :: IO()
main = do
  datain <- Textio.readFile "database.csv"
  let userslist = filetoUsers datain
  initial_state <- ServerState <$>
    newIORef userslist
  cfg <- defaultSpockCfg () PCNoDatabase initial_state
  runSpock 8080 (spock cfg app)
