-- Importamos los módulos necesarios
import Database.HDBC
import Database.HDBC.Sqlite3 (connectSqlite3)

-- Función para crear la tabla de libros
createBooksTable :: Connection -> IO ()
createBooksTable conn = do
    run conn "CREATE TABLE books (id INTEGER PRIMARY KEY, title TEXT, author TEXT)" []
    commit conn

-- Función para insertar un libro en la tabla
insertBook :: Connection -> String -> String -> IO Integer
insertBook conn title author = do
    stmt <- prepare conn "INSERT INTO books (title, author) VALUES (?, ?)"
    execute stmt [toSql title, toSql author]
    commit conn
    lastInsertRowId conn

-- Función para obtener todos los libros
getAllBooks :: Connection -> IO [(Integer, String, String)]
getAllBooks conn = do
    stmt <- prepare conn "SELECT id, title, author FROM books"
    execute stmt []
    fetchAllRows stmt

-- Función principal
main :: IO ()
main = do
    -- Conectamos a la base de datos SQLite
    conn <- connectSqlite3 "mydatabase.db"

    -- Creamos la tabla de libros
    createBooksTable conn

    -- Insertamos algunos libros
    bookId1 <- insertBook conn "El Gran Gatsby" "F. Scott Fitzgerald"
    bookId2 <- insertBook conn "1984" "George Orwell"

    -- Obtenemos todos los libros
    books <- getAllBooks conn
    putStrLn "Libros en la base de datos:"
    mapM_ (\(id, title, author) -> putStrLn $ show id ++ ": " ++ title ++ " by " ++ author) books

    -- Cerramos la conexión
    disconnect conn