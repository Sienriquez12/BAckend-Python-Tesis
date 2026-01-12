"""
APLICACIÓN FASTAPI - Club Match IA
Punto de entrada principal de la API
"""

from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
import db_config
from controller import router as club_router
from recommendation_controller import router as recommendation_router

# ==========================================
# INICIALIZACIÓN DE FASTAPI
# ==========================================

app = FastAPI(
    title="Club Match IA API",
    description="""
    ## 🎯 API para Club Match - Sistema de Asignación Inteligente de Clubes
    
    Esta API permite:
    * 📋 **Consultar clubes** disponibles en la universidad
    * 🔍 **Filtrar clubes** por tipo
    * 📊 **Obtener estadísticas** de clubes
    * 🔗 **Integración con PostgreSQL** en DigitalOcean
    
    ### 🚀 Endpoints Principales:
    - `/api/clubes` - Lista todos los clubes
    - `/api/clubes/{id}` - Obtiene un club específico
    - `/api/clubes/tipo/{tipo}` - Filtra clubes por tipo
    - `/api/health` - Estado de la API y BD
    
    ### 🔒 Autenticación:
    Actualmente sin autenticación (desarrollo)
    """,
    version="1.0.0",
    contact={
        "name": "Club Match Team",
        "email": "support@clubmatch.com",
    },
    license_info={
        "name": "MIT License",
    },
    docs_url="/docs",
    redoc_url="/redoc",
    openapi_tags=[
        {
            "name": "Clubes",
            "description": "Operaciones relacionadas con clubes universitarios"
        },
        {
            "name": "Recomendaciones IA",
            "description": "Sistema de recomendación inteligente de clubes usando Machine Learning"
        },
        {
            "name": "Info",
            "description": "Información general de la API"
        },
        {
            "name": "Health",
            "description": "Estado y monitoreo del sistema"
        }
    ]
)

# ==========================================
# CONFIGURAR CORS (Para permitir solicitudes del frontend)
# ==========================================

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # En producción, especificar dominios
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# ==========================================
# REGISTRAR CONTROLADORES
# ==========================================

app.include_router(club_router)
app.include_router(recommendation_router)

# ==========================================
# ENDPOINTS GENERALES
# ==========================================

@app.get("/", tags=["Info"])
def root():
    """Endpoint raíz con información de la API"""
    return {
        "nombre": "Club Match IA API",
        "version": "1.0.0",
        "descripcion": "API para obtener datos de clubes y generar recomendaciones con IA",
        "endpoints": {
            "clubes": "/api/clubes",
            "recomendaciones": "/api/recommendations/{student_id}",
            "documentación": "/docs",
            "health": "/api/health"
        }
    }

@app.get("/api/health", tags=["Health"])
def health_check():
    """Verifica que la API y la conexión a BD están funcionando"""
    try:
        db_config.init_connection_pool()
        conn = db_config.get_connection()
        if conn:
            cursor = conn.cursor()
            cursor.execute("SELECT version()")
            version = cursor.fetchone()[0]
            cursor.close()
            db_config.release_connection(conn)
            
            return {
                "status": "✓ OK",
                "database": "✓ Conectado",
                "version": version
            }
        else:
            return {
                "status": "✗ Error",
                "database": "✗ No hay conexión",
            }
    except Exception as e:
        return {
            "status": "✗ Error",
            "database": "✗ Error de conexión",
            "detalle": str(e)
        }

# ==========================================
# EVENTO DE STARTUP
# ==========================================

@app.on_event("startup")
async def startup_event():
    """Se ejecuta cuando inicia la aplicación"""
    print("\n" + "="*50)
    print("🚀 Iniciando Club Match IA API")
    print("="*50)
    
    if db_config.init_connection_pool():
        print("✓ Pool de conexiones inicializado")
    else:
        print("✗ Error al inicializar pool de conexiones")

@app.on_event("shutdown")
async def shutdown_event():
    """Se ejecuta cuando se apaga la aplicación"""
    print("\n" + "="*50)
    print("⛔ Cerrando Club Match IA API")
    print("="*50)
    db_config.close_all_connections()

# ==========================================
# PUNTO DE ENTRADA
# ==========================================

if __name__ == "__main__":
    import uvicorn
    
    print("\n" + "="*50)
    print("🔧 Configurando servidor...")
    print("="*50)
    print("📍 API en: http://localhost:8000")
    print("📚 Documentación: http://localhost:8000/docs")
    print("="*50 + "\n")
    
    uvicorn.run(
        "app:app",
        host="0.0.0.0",
        port=8000,
        reload=True
    )
