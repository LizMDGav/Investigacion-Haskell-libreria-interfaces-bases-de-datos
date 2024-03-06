import Database.PostgreSQL.Simple

-- Definir una función para conectar a la base de datos
connectToDB :: IO Connection
connectToDB = connect defaultConnectInfo
    { connectHost = "localhost"
    , connectUser = "tu_usuario"
    , connectPassword = "tu_contraseña"
    , connectDatabase = "tu_basededatos"
    }

-- Función para insertar datos en la tabla
insertData :: Connection -> IO ()
insertData conn = do
    execute conn "INSERT INTO personas (nombre, edad) VALUES (?, ?)" ("Juan", 30)
    putStrLn "Datos insertados correctamente."

-- Función para seleccionar datos de la tabla
selectData :: Connection -> IO ()
selectData conn = do
    rows <- query_ conn "SELECT * FROM personas"
    mapM_ print (rows :: [(Int, String, Int)])

main :: IO ()
main = do
    -- Conectar a la base de datos
    conn <- connectToDB

    -- Insertar datos
    insertData conn

    -- Seleccionar y mostrar datos
    selectData conn

    -- Cerrar la conexión
    close conn