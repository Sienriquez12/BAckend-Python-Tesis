"""
RECOMMENDATION CONTROLLER: Endpoints de Recomendación IA
Responsabilidad: Exponer API para generar recomendaciones
"""

from fastapi import APIRouter, HTTPException, Path
from pydantic import BaseModel
from typing import List, Optional
from recommendation_service import RecommendationService

# Router para endpoints de recomendaciones
router = APIRouter(prefix="/api/recommendations", tags=["Recomendaciones IA"])

# ==========================================
# MODELOS PYDANTIC
# ==========================================

class Recomendacion(BaseModel):
    club_id: int
    club_name: str
    club_type: str
    afinidad: float
    afinidad_porcentaje: float
    capacidad_disponible: int
    horas_semanales: int
    descripcion: str
    razones_match: List[str]

class EstudianteInfo(BaseModel):
    id: int
    nombre: str
    carrera: Optional[str] = None
    semestre: int
    intereses: List[str]
    grupo_cluster: int

class RecomendacionResponse(BaseModel):
    error: bool
    estudiante: Optional[EstudianteInfo] = None
    recomendaciones: Optional[List[Recomendacion]] = None
    metadata: Optional[dict] = None
    mensaje: Optional[str] = None

# ==========================================
# ENDPOINTS
# ==========================================

@router.post("/{student_id}", response_model=RecomendacionResponse, summary="Generar recomendaciones")
def generar_recomendaciones(
    student_id: int = Path(..., gt=0, description="ID del estudiante")
):
    """
    ## 🤖 Genera recomendaciones de clubes usando IA
    
    **Algoritmo utilizado:**
    1. 📊 Obtención de datos (estudiante + clubes desde PostgreSQL)
    2. 🔍 Clustering (análisis de contexto poblacional)
    3. 🧮 Matriz de Afinidad (cálculo de compatibilidad)
    4. 🏆 Ranking optimizado (selección de mejores matches)
    
    **Factores considerados:**
    - Coincidencia de intereses (40%)
    - Coincidencia de soft skills (25%)
    - Compatibilidad de carrera (15%)
    - Razones/motivaciones (10%)
    - Semestre compatible (5%)
    - Disponibilidad horaria (5%)
    
    **Parámetros:**
    - student_id: ID del estudiante (debe existir en BD)
    
    **Retorna:**
    - Top 10 clubes recomendados con scores de afinidad
    - Explicación de por qué se recomienda cada club
    - Metadata del procesamiento
    """
    try:
        print(f"\n{'='*70}")
        print(f"🎯 Nueva solicitud de recomendación para estudiante ID: {student_id}")
        print(f"{'='*70}")
        
        resultado = RecommendationService.generar_recomendaciones(student_id)
        
        if resultado.get('error'):
            raise HTTPException(
                status_code=404 if 'no encontrado' in resultado['mensaje'] else 400,
                detail=resultado['mensaje']
            )
        
        return resultado
        
    except HTTPException:
        raise
    except Exception as e:
        print(f"✗ Error inesperado: {str(e)}")
        raise HTTPException(
            status_code=500,
            detail=f"Error interno al generar recomendaciones: {str(e)}"
        )

@router.get("/{student_id}/quick", summary="Vista rápida de recomendaciones")
def vista_rapida_recomendaciones(
    student_id: int = Path(..., gt=0, description="ID del estudiante")
):
    """
    ## ⚡ Vista rápida: Solo nombres y scores
    
    Versión ligera que retorna solo:
    - Nombres de clubes recomendados
    - Scores de afinidad
    - Sin detalles extendidos
    """
    try:
        resultado = RecommendationService.generar_recomendaciones(student_id)
        
        if resultado.get('error'):
            raise HTTPException(status_code=404, detail=resultado['mensaje'])
        
        # Simplificar respuesta
        return {
            'estudiante': resultado['estudiante']['nombre'],
            'top_5': [
                {
                    'club': r['club_name'],
                    'afinidad': f"{r['afinidad_porcentaje']}%",
                    'tipo': r['club_type']
                }
                for r in resultado['recomendaciones'][:5]
            ],
            'tiempo': resultado['metadata']['tiempo_procesamiento_segundos']
        }
        
    except HTTPException:
        raise
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))

@router.get("/test/health", summary="Test de conectividad")
def test_recomendacion():
    """
    ## 🔧 Test de conectividad del módulo de recomendaciones
    
    Verifica que:
    - El servicio está activo
    - La conexión a BD funciona
    - Los repositorios responden
    """
    try:
        from recommendation_repository import RecommendationRepository
        import db_config
        
        # Test de conexión
        db_config.init_connection_pool()
        
        # Test de consulta
        clubes = RecommendationRepository.obtener_clubes_activos()
        
        return {
            "status": "✓ OK",
            "servicio": "Recommendation Service",
            "bd_conectada": True,
            "clubes_disponibles": len(clubes),
            "mensaje": "Sistema de recomendaciones operativo"
        }
    except Exception as e:
        return {
            "status": "✗ Error",
            "servicio": "Recommendation Service",
            "bd_conectada": False,
            "error": str(e)
        }
