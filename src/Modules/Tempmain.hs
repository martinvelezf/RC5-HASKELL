{-# LANGUAGE OverloadedStrings #-}
import System.IO
import qualified Data.Text.IO as Textio
import Modules.Datamng
main = do
      datain <- Textio.readFile "database.csv"
      let userslist = filetoUsers datain
          dataout = userstofile userslist
          in Textio.writeFile "database.csv" dataout
