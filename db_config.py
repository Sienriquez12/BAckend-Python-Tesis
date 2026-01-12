import os
from dotenv import load_dotenv
import psycopg2
from psycopg2 import pool

# Cargar variables de entorno desde el archivo .env
load_dotenv()

# Configuración de la base de datos
DB_CONFIG = {
    'host': os.getenv('DB_HOST'),
    'port': os.getenv('DB_PORT'),
    'database': os.getenv('DB_NAME'),
    'user': os.getenv('DB_USERNAME'),
    'password': os.getenv('DB_PASSWORD'),
    'sslmode': os.getenv('DB_SSLMODE', 'require')
}

# Pool de conexiones para mejor rendimiento
connection_pool = None

def init_connection_pool():
    """Inicializa el pool de conexiones a la base de datos"""
    global connection_pool
    try:
        connection_pool = psycopg2.pool.SimpleConnectionPool(
            1, 20,  # mínimo y máximo de conexiones
            **DB_CONFIG
        )
        print("✓ Pool de conexiones inicializado correctamente")
        return True
    except Exception as e:
        print(f"✗ Error al inicializar pool de conexiones: {e}")
        return False

def get_connection():
    """Obtiene una conexión del pool"""
    if connection_pool:
        return connection_pool.getconn()
    return None

def release_connection(conn):
    """Devuelve una conexión al pool"""
    if connection_pool and conn:
        connection_pool.putconn(conn)

def close_all_connections():
    """Cierra todas las conexiones del pool"""
    if connection_pool:
        connection_pool.closeall()
        print("✓ Todas las conexiones cerradas")

# Ejemplo de uso
if __name__ == "__main__":
    # Probar conexión
    if init_connection_pool():
        conn = get_connection()
        if conn:
            try:
                cursor = conn.cursor()
                cursor.execute("SELECT version();")
                db_version = cursor.fetchone()
                print(f"✓ Conectado a PostgreSQL: {db_version[0]}")
                cursor.close()
            except Exception as e:
                print(f"✗ Error en consulta de prueba: {e}")
            finally:
                release_connection(conn)
        close_all_connections()
