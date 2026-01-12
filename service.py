"""
CAPA SERVICE: Lógica de negocio
Responsabilidad: Procesar datos, validaciones y reglas de negocio
"""

from repository import ClubRepository
from typing import List, Dict, Optional

class ClubService:
    """Servicio para operaciones de Clubes"""
    
    @staticmethod
    def obtener_todos_clubes() -> List[Dict]:
        """
        Obtiene todos los clubes activos
        Realiza validaciones y procesamiento de datos
        """
        try:
            clubs = ClubRepository.obtener_todos_clubes()
            
            # Aquí puedes agregar lógica adicional como:
            # - Filtros avanzados
            # - Cálculos adicionales
            # - Validaciones
            
            if not clubs:
                print("⚠️  No hay clubes disponibles")
                return []
            
            print(f"✓ {len(clubs)} clubes obtenidos del repositorio")
            return clubs
        except Exception as e:
            print(f"✗ Error en servicio: {str(e)}")
            raise
    
    @staticmethod
    def obtener_club_por_id(club_id: int) -> Optional[Dict]:
        """
        Obtiene un club específico
        Realiza validaciones del ID
        """
        if not isinstance(club_id, int) or club_id <= 0:
            print(f"✗ ID inválido: {club_id}")
            return None
        
        try:
            club = ClubRepository.obtener_club_por_id(club_id)
            
            if not club:
                print(f"⚠️  Club con ID {club_id} no encontrado")
                return None
            
            print(f"✓ Club obtenido: {club['name']}")
            return club
        except Exception as e:
            print(f"✗ Error en servicio: {str(e)}")
            raise
    
    @staticmethod
    def obtener_clubs_por_tipo(club_type_id: int) -> List[Dict]:
        """
        Obtiene clubes que tienen un tipo específico
        """
        try:
            todos_clubs = ClubRepository.obtener_todos_clubes()
            clubs_filtrados = [
                club for club in todos_clubs 
                if club['club_type_id'] == club_type_id
            ]
            
            print(f"✓ {len(clubs_filtrados)} clubes encontrados para tipo ID: {club_type_id}")
            return clubs_filtrados
        except Exception as e:
            print(f"✗ Error en servicio: {str(e)}")
            raise
    
    @staticmethod
    def contar_clubes() -> int:
        """Retorna la cantidad total de clubes"""
        try:
            clubs = ClubRepository.obtener_todos_clubes()
            return len(clubs)
        except Exception as e:
            print(f"✗ Error en servicio: {str(e)}")
            raise
