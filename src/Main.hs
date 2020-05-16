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

data User = User { firstName :: Text,
                   lastName :: Text,
                   email :: Text,
                   birthday :: Text,
                   password :: Text,
                   occupation :: Text
                 }
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
    let userTuple = Text.concat[email,": ",password]
    -- We should use RC5 here
    if email == "nicolas.serrano@yachaytech.edu.ec" && password == "encryptedpassword"
      then redirect "welcome/"
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
          "Birthday: "
          input_ [name_ "birthday"]
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
        input_ [type_ "submit", value_ "Create User"]
      br_ []
      a_ [href_ "/"] "Go back to the Homepage"

  post "create" $ do
    firstName <- param' "firstName"
    lastName <- param' "lastName"
    email <- param' "email"
    birthday <- param' "birthday"
    password <- param' "password"
    occupation <- param' "occupation"
    userList <- users <$> getState
    liftIO $ atomicModifyIORef' userList $ \user ->
      (user <> [User firstName lastName email birthday password occupation], ())
    let result = Text.concat[firstName,",",lastName,",",email,",",birthday,",",password,",",occupation]
    lucid $ do
      h1_ "User created"

  get "welcome" $ do
    users' <- getState >>= (liftIO . readIORef . users)
    lucid $ do
      h1_ "Welcome to the Company Intranet"
      p_ "The registered users are:"
      ul_ $ forM_ users' $ \user -> li_ $ do
        toHtml (firstName user)
        ", "
        toHtml(lastName user)
        ", "
        toHtml(email user)
        ", "
        toHtml(birthday user)
        ", "
        toHtml(password user)
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
  initial_state <- ServerState <$>
    newIORef [ User "Carlos" "Munoz" "carlos@yachay.edu.ec" "01/01/1995" "anencryptedpassword" "mathematician",
               User "Nico" "Serrano" "nico@inno-maps.com" "22/12/1995" "anencryptedpassword" "student",
               User "Martin" "Velez" "martin@yachay.edu.ec" "02/02/1995" "anencryptedpassword" "engineer"
             ]
  cfg <- defaultSpockCfg () PCNoDatabase initial_state
  runSpock 8080 (spock cfg app)
