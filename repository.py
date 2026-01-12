"""
CAPA REPOSITORY: Acceso a datos (Base de Datos)
Responsabilidad: Comunicarse directamente con PostgreSQL
"""

import json
import db_config
from contextlib import contextmanager

@contextmanager
def get_db():
    """Context manager para obtener conexión de la BD"""
    conn = db_config.get_connection()
    try:
        yield conn
    finally:
        if conn:
            db_config.release_connection(conn)

class ClubRepository:
    """Repositorio para operaciones CRUD de Clubes"""
    
    @staticmethod
    def obtener_todos_clubes():
        """Obtiene todos los clubes de la base de datos"""
        try:
            with get_db() as conn:
                cursor = conn.cursor()
                cursor.execute("""
                    SELECT 
                        id, 
                        name, 
                        capacity, 
                        description,
                        record_status,
                        whatsapp_group_link,
                        club_type_id,
                        created_at,
                        updated_at
                    FROM club
                    WHERE record_status = 'true'
                    ORDER BY name
                """)
                
                clubs = []
                for row in cursor.fetchall():
                    id, name, capacity, description, record_status, whatsapp_link, club_type_id, created_at, updated_at = row
                    clubs.append({
                        "id": id,
                        "name": name,
                        "capacity": capacity,
                        "description": description,
                        "record_status": str(record_status),  # Convertir a string
                        "whatsapp_group_link": whatsapp_link,
                        "club_type_id": club_type_id,
                        "created_at": str(created_at),
                        "updated_at": str(updated_at)
                    })
                
                cursor.close()
                return clubs
        except Exception as e:
            print(f"✗ Error en repository: {str(e)}")
            raise
    
    @staticmethod
    def obtener_club_por_id(club_id: int):
        """Obtiene un club específico por su ID"""
        try:
            with get_db() as conn:
                cursor = conn.cursor()
                cursor.execute("""
                    SELECT 
                        id, 
                        name, 
                        capacity, 
                        description,
                        record_status,
                        whatsapp_group_link,
                        club_type_id,
                        created_at,
                        updated_at
                    FROM club
                    WHERE id = %s
                """, (club_id,))
                
                row = cursor.fetchone()
                cursor.close()
                
                if not row:
                    return None
                
                id, name, capacity, description, record_status, whatsapp_link, club_type_id, created_at, updated_at = row
                
                return {
                    "id": id,
                    "name": name,
                    "capacity": capacity,
                    "description": description,
                    "record_status": str(record_status),  # Convertir a string
                    "whatsapp_group_link": whatsapp_link,
                    "club_type_id": club_type_id,
                    "created_at": str(created_at),
                    "updated_at": str(updated_at)
                }
        except Exception as e:
            print(f"✗ Error en repository: {str(e)}")
            raise
