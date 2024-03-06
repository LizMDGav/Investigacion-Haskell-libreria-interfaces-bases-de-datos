import Servant

type API = "users" :> ReqBody '[JSON] User :> Post '[JSON] UserId

data User = User { email :: Text, name :: Text }
data UserId = UserId Int

server :: Server API
server = insertUser

insertUser :: User -> Handler UserId
insertUser user = do
  result <- try $ M.query conn "insert `user` (`email`, `name`) values (?, ?)" (email user, name user)
  case result of
    Left err -> throwError err
    Right _ -> return $ UserId 1

app :: Application
app = serve api server

main :: IO ()
main = do
  conn <- connectDefault "localhost" "mydatabase" "myusername" "mypassword"
  putStrLn "Connected to MySQL database!"
  run 8080 app