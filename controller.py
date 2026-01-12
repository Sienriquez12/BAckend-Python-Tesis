"""
CAPA CONTROLLER: Endpoints de la API
Responsabilidad: Definir rutas HTTP y validar solicitudes
"""

from fastapi import APIRouter, HTTPException, Path, Query
from pydantic import BaseModel
from typing import List, Optional
from service import ClubService

# Modelo de respuesta
class Club(BaseModel):
    id: int
    name: str
    capacity: int
    description: Optional[str] = None
    record_status: str
    whatsapp_group_link: Optional[str] = None
    club_type_id: int
    created_at: Optional[str] = None
    updated_at: Optional[str] = None

# Router para agrupar endpoints de Clubes
router = APIRouter(prefix="/api/clubes", tags=["Clubes"])

@router.get("", response_model=List[Club], summary="Obtener todos los clubes")
def obtener_clubes():
    """
    Obtiene la lista de todos los clubes activos
    
    **Retorna:**
    - Lista de clubes con sus datos
    """
    try:
        clubs = ClubService.obtener_todos_clubes()
        
        if not clubs:
            raise HTTPException(status_code=404, detail="No hay clubes disponibles")
        
        return clubs
    except HTTPException:
        raise
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Error interno: {str(e)}")

@router.get("/{club_id}", response_model=Club, summary="Obtener un club específico")
def obtener_club(club_id: int = Path(..., gt=0, description="ID del club")):
    """
    Obtiene un club específico por su ID
    
    **Parámetros:**
    - club_id: ID del club (debe ser mayor a 0)
    
    **Retorna:**
    - Datos del club solicitado
    """
    try:
        club = ClubService.obtener_club_por_id(club_id)
        
        if not club:
            raise HTTPException(status_code=404, detail=f"Club con ID {club_id} no encontrado")
        
        return club
    except HTTPException:
        raise
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Error interno: {str(e)}")

@router.get("/tipo/{club_type_id}", response_model=List[Club], summary="Obtener clubs por tipo")
def obtener_clubs_por_tipo(club_type_id: int = Path(..., gt=0, description="ID del tipo de club")):
    """
    Obtiene todos los clubs que tienen un tipo específico
    
    **Parámetros:**
    - club_type_id: ID del tipo de club a buscar
    
    **Retorna:**
    - Lista de clubs del tipo especificado
    """
    try:
        clubs = ClubService.obtener_clubs_por_tipo(club_type_id)
        
        if not clubs:
            raise HTTPException(
                status_code=404, 
                detail=f"No hay clubs para el tipo ID: {club_type_id}"
            )
        
        return clubs
    except HTTPException:
        raise
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Error interno: {str(e)}")

@router.get("/estadisticas/total", summary="Contar total de clubs")
def contar_clubs():
    """
    Retorna la cantidad total de clubes
    
    **Retorna:**
    - Cantidad de clubes
    """
    try:
        total = ClubService.contar_clubes()
        return {
            "total_clubs": total,
            "mensaje": f"Hay {total} clubes registrados"
        }
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Error interno: {str(e)}")
