# 🤖 Club Match IA - Sistema de Recomendación Inteligente

## 📋 Descripción

Sistema de recomendación de clubes universitarios basado en **Inteligencia Artificial** que utiliza algoritmos de Machine Learning para asignar estudiantes a clubes según su perfil, intereses y habilidades.

### 🎯 Características Principales

- ✅ **Recomendaciones personalizadas** usando matriz de afinidad
- ✅ **Clustering con K-Means** para análisis de contexto poblacional
- ✅ **6 factores ponderados** de compatibilidad
- ✅ **API REST con FastAPI** y documentación Swagger
- ✅ **Base de datos PostgreSQL** en DigitalOcean
- ✅ **Arquitectura por capas** (Repository-Service-Controller)

---

## 🏗️ Arquitectura del Sistema

```
📦 ClubMatch/IA
├── 📄 app.py                          # Punto de entrada FastAPI
├── 📄 db_config.py                    # Configuración de PostgreSQL
├── 📄 .env                            # Variables de entorno
│
├── 📂 Módulo de Clubes
│   ├── 📄 repository.py               # Acceso a datos (BD)
│   ├── 📄 service.py                  # Lógica de negocio
│   └── 📄 controller.py               # Endpoints REST
│
├── 📂 Módulo de Recomendaciones IA
│   ├── 📄 recommendation_repository.py   # Obtención de datos
│   ├── 📄 recommendation_service.py      # Algoritmos de IA
│   └── 📄 recommendation_controller.py   # API de recomendaciones
│
└── 📂 Otros
    ├── 📄 tesis.py                    # Algoritmo original (investigación)
    ├── 📄 data.sql                    # Estructura de BD
    └── 📄 requirements.txt            # Dependencias Python
```

---

## 🔄 Flujo del Sistema de Recomendación

```
┌─────────────────────────┐
│ Cliente envía student_id│
└───────────┬─────────────┘
            │
            ▼
┌─────────────────────────────────────┐
│ recommendation_controller.py         │
│ POST /api/recommendations/{id}       │
└───────────┬─────────────────────────┘
            │
            ▼
┌─────────────────────────────────────┐
│ recommendation_service.py            │
│ generar_recomendaciones()            │
│                                      │
│  FASE 1: Obtención de datos         │
│  └─> recommendation_repository       │
│                                      │
│  FASE 2: Clustering (K-Means)       │
│  └─> Contexto poblacional            │
│                                      │
│  FASE 3: Matriz de Afinidad         │
│  └─> 6 factores ponderados           │
│                                      │
│  FASE 4: Ranking + Filtros          │
│  └─> Top 10 mejores matches          │
└───────────┬─────────────────────────┘
            │
            ▼
┌─────────────────────────┐
│ Guardar en               │
│ recommendation_log       │
└─────────────────────────┘
```

---

## 🧮 Algoritmo de Recomendación

### **FASE 1: Obtención de Datos**
Extrae información completa del estudiante y clubes desde PostgreSQL:

```python
Estudiante:
  - Datos básicos (nombre, carrera, semestre)
  - Intereses (Fútbol, Programación, etc.)
  - Soft Skills (Liderazgo, Trabajo en equipo, etc.)
  - Inteligencias Múltiples (scores 1-5)
  - Preferencias (tipo de club, horas disponibles)

Clubes:
  - Datos básicos (nombre, capacidad, tipo)
  - Intereses requeridos
  - Soft Skills a desarrollar
  - Carreras objetivo
  - Perfil (horas semanales, semestres)
```

### **FASE 2: Clustering (K-Means)**
Agrupa estudiantes similares para entender el contexto:
```python
- Vectoriza intereses de todos los estudiantes
- Aplica K-Means (4 grupos)
- Identifica el cluster del estudiante objetivo
```

### **FASE 3: Matriz de Afinidad**
Calcula compatibilidad estudiante-club con **6 factores ponderados**:

| Factor | Peso | Descripción |
|--------|------|-------------|
| **Intereses compartidos** | 40% | Coincidencia entre intereses del estudiante y del club |
| **Soft Skills** | 25% | Habilidades blandas compatibles |
| **Carrera** | 15% | Si la carrera del estudiante está en target del club |
| **Razones/Motivaciones** | 10% | Coincidencia de motivaciones para unirse |
| **Semestre compatible** | 5% | Si el estudiante está en el rango de semestres del club |
| **Disponibilidad horaria** | 5% | Si tiene suficientes horas semanales disponibles |

**Fórmula:**
```python
afinidad = (
    coincidencia_intereses * 0.40 +
    coincidencia_skills * 0.25 +
    compatibilidad_carrera * 0.15 +
    coincidencia_razones * 0.10 +
    semestre_compatible * 0.05 +
    disponibilidad_horas * 0.05
)

# Penalización si el club está lleno
if club_lleno:
    afinidad *= 0.5
```

### **FASE 4: Ranking y Filtros**
Ordena y filtra clubes:
```python
- Filtro mínimo: afinidad >= 20%
- Filtro de capacidad: hasta 110% del cupo
- Ordenar por afinidad descendente
- Seleccionar Top 10
- Generar explicaciones personalizadas
```

---

## 🚀 Instalación

### **1. Requisitos Previos**
```bash
- Python 3.10+
- PostgreSQL 18+
- pip (gestor de paquetes)
```

### **2. Clonar o Descargar el Proyecto**
```bash
cd C:\Users\sienriquez1\Documents\APP\ClubMatch\IA
```

### **3. Crear Entorno Virtual**
```bash
python -m venv venv
venv\Scripts\activate  # Windows
```

### **4. Instalar Dependencias**
```bash
pip install -r requirements.txt
```

**Contenido de requirements.txt:**
```txt
pandas>=2.0.0
numpy>=1.24.0
matplotlib>=3.7.0
seaborn>=0.12.0
scikit-learn>=1.3.0
psycopg2-binary>=2.9.0
python-dotenv>=1.0.0
fastapi>=0.104.0
uvicorn>=0.24.0
```

### **5. Configurar Variables de Entorno**
Crear archivo `.env`:
```env
DB_HOST=tu-servidor.db.ondigitalocean.com
DB_PORT=25060
DB_NAME=tu_base_de_datos
DB_USERNAME=tu_usuario
DB_PASSWORD=tu_contraseña_segura
DB_SSLMODE=require
```

### **6. Verificar Conexión a BD**
```bash
python db_config.py
```

**Salida esperada:**
```
✓ Pool de conexiones inicializado correctamente
✓ Conectado a PostgreSQL: PostgreSQL 18.1 on x86_64-pc-linux-gnu
✓ Todas las conexiones cerradas
```

---

## 🎮 Uso

### **Ejecutar el Servidor**
```bash
python app.py
```

**Salida esperada:**
```
==================================================
🚀 Iniciando Club Match IA API
==================================================
✓ Pool de conexiones inicializado
==================================================
🔧 Configurando servidor...
==================================================
📍 API en: http://localhost:8000
📚 Documentación: http://localhost:8000/docs
==================================================
```

### **Acceder a la Documentación**
Abre en tu navegador:
- 📚 **Swagger UI**: http://localhost:8000/docs
- 📖 **ReDoc**: http://localhost:8000/redoc

---

## 📡 Endpoints Disponibles

### **1. Información General**
```http
GET /
```
Retorna información básica de la API.

---

### **2. Clubes**

#### Obtener todos los clubes
```http
GET /api/clubes
```

#### Obtener un club específico
```http
GET /api/clubes/{club_id}
```

#### Obtener clubes por tipo
```http
GET /api/clubes/tipo/{club_type_id}
```

#### Estadísticas
```http
GET /api/clubes/estadisticas/total
```

---

### **3. Recomendaciones IA** ⭐

#### Generar recomendación completa
```http
POST /api/recommendations/{student_id}
```

**Ejemplo de solicitud:**
```bash
curl -X POST http://localhost:8000/api/recommendations/2
```

**Respuesta de ejemplo:**
```json
{
  "error": false,
  "estudiante": {
    "id": 2,
    "nombre": "Estudiante ESPE",
    "carrera": "ITIN",
    "semestre": 3,
    "intereses": ["Fútbol", "Baloncesto", "Natación"],
    "grupo_cluster": 1
  },
  "recomendaciones": [
    {
      "club_id": 1,
      "club_name": "Club Atlético Central",
      "club_type": "Deportivo",
      "afinidad": 0.785,
      "afinidad_porcentaje": 78.5,
      "capacidad_disponible": 149,
      "horas_semanales": 6,
      "descripcion": "Club deportivo enfocado en fútbol amateur",
      "razones_match": [
        "Comparten intereses: Fútbol, Baloncesto, Atletismo",
        "Desarrollarás: Trabajo en equipo, Liderazgo",
        "¡Match perfecto! (70%+ compatibilidad)"
      ]
    },
    {
      "club_id": 4,
      "club_name": "Club Literario Aurora",
      "club_type": "Cultural y artístico",
      "afinidad": 0.456,
      "afinidad_porcentaje": 45.6,
      "capacidad_disponible": 50,
      "horas_semanales": 2,
      "descripcion": "Club privado de lectura y café",
      "razones_match": [
        "Desarrollarás: Comunicación efectiva, Creatividad",
        "Buena compatibilidad (50%+)"
      ]
    }
  ],
  "metadata": {
    "total_clubes_evaluados": 3,
    "tiempo_procesamiento_segundos": 0.34,
    "algoritmo": "Matriz de Afinidad + Filtros Inteligentes"
  }
}
```

#### Vista rápida (solo nombres y scores)
```http
GET /api/recommendations/{student_id}/quick
```

**Respuesta:**
```json
{
  "estudiante": "Estudiante ESPE",
  "top_5": [
    {
      "club": "Club Atlético Central",
      "afinidad": "78.5%",
      "tipo": "Deportivo"
    }
  ],
  "tiempo": 0.34
}
```

#### Test de conectividad
```http
GET /api/recommendations/test/health
```

---

### **4. Health Check**
```http
GET /api/health
```

Verifica el estado de la API y la conexión a la base de datos.

---

## 🗄️ Estructura de la Base de Datos

### **Tablas Principales**

```sql
-- Clubes
club (id, name, capacity, description, club_type_id)
club_profile (weekly_hours, min_semester, max_semester)
club_interests (club_id, interest_id)
club_soft_skills (club_id, soft_skill_id)
club_reasons (club_id, club_reason_id)

-- Estudiantes
student (id, career_id, semester_number, weekly_availability_hours)
student_interests (student_id, interest_id)
student_soft_skills (student_id, soft_skill_id)
student_mi_answer (student_id, mi_question_id, score)

-- Catálogos
interest (30 intereses disponibles)
soft_skill (30 habilidades blandas)
club_reason (12 razones para unirse)
intelligence_type (8 tipos de inteligencias múltiples)
club_type (7 tipos de clubes)

-- Log de Recomendaciones
recommendation_log (student_id, club_id, affinity_score, rank_position)
```

---

## 📊 Datos de Ejemplo

### **Intereses Disponibles (30)**
- **Deportivos**: Fútbol, Baloncesto, Voleibol, Atletismo, Natación
- **Tecnológicos**: Robótica, Programación, Ciberseguridad, IA, Electrónica
- **Artísticos**: Fotografía, Música, Teatro, Danza, Lectura
- **Sociales**: Voluntariado, Medio Ambiente, Derechos Humanos
- **Académicos**: Debate, Investigación, Escritura

### **Tipos de Clubes (7)**
1. Deportivo
2. Académico
3. Cultural y artístico
4. Social y voluntariado
5. Tecnológico
6. Emprendimiento y liderazgo
7. Recreativo

### **Soft Skills (30)**
- Trabajo en equipo
- Comunicación efectiva
- Liderazgo
- Responsabilidad
- Empatía
- Resolución de conflictos
- Pensamiento crítico
- Creatividad
- (y 22 más...)

---

## 🧪 Pruebas

### **Test Manual con Swagger**
1. Ir a http://localhost:8000/docs
2. Expandir `POST /api/recommendations/{student_id}`
3. Hacer clic en "Try it out"
4. Ingresar `student_id: 2`
5. Hacer clic en "Execute"

### **Test con cURL**
```bash
# Generar recomendación
curl -X POST http://localhost:8000/api/recommendations/2

# Vista rápida
curl http://localhost:8000/api/recommendations/2/quick

# Health check
curl http://localhost:8000/api/recommendations/test/health
```

### **Test con Python**
```python
import requests

# Generar recomendación
response = requests.post('http://localhost:8000/api/recommendations/2')
data = response.json()

print(f"Estudiante: {data['estudiante']['nombre']}")
print(f"Top club: {data['recomendaciones'][0]['club_name']}")
print(f"Afinidad: {data['recomendaciones'][0]['afinidad_porcentaje']}%")
```

---

## 📈 Rendimiento

- ⚡ Tiempo promedio de respuesta: **0.3 - 0.5 segundos**
- 🔄 Procesamiento de clustering: **< 0.1s**
- 🧮 Cálculo de matriz de afinidad: **< 0.2s**
- 💾 Consultas a BD optimizadas con pool de conexiones

---

## 🔧 Configuración Avanzada

### **Ajustar Pesos de Afinidad**
Editar `recommendation_service.py`:
```python
# Líneas 96-105
score += (coincidencias_intereses / ...) * 0.40  # Cambiar peso
score += (coincidencias_skills / ...) * 0.25     # Cambiar peso
# ...
```

### **Cambiar Número de Clusters**
```python
# Línea 65
n_clusters = min(4, len(estudiantes))  # Cambiar a 5, 6, etc.
```

### **Ajustar Límite de Recomendaciones**
```python
# Línea 142
return recomendaciones[:10]  # Cambiar a 15, 20, etc.
```

---

## 🐛 Solución de Problemas

### **Error: "No module named 'fastapi'"**
```bash
pip install fastapi uvicorn
```

### **Error: "psycopg2 not found"**
```bash
pip install psycopg2-binary
```

### **Error de conexión a PostgreSQL**
Verificar que el archivo `.env` tenga las credenciales correctas.

### **Puerto 8000 ya en uso**
Cambiar puerto en `app.py`:
```python
uvicorn.run("app:app", host="0.0.0.0", port=8001)  # Cambiar a 8001
```

---

## 📚 Referencias

- **Algoritmo base**: `tesis.py` (investigación original)
- **Estructura BD**: `data.sql`
- **Framework**: [FastAPI Documentation](https://fastapi.tiangolo.com/)
- **Machine Learning**: [Scikit-learn](https://scikit-learn.org/)
- **Base de datos**: PostgreSQL 18 en DigitalOcean

---

## 👥 Autor

**Proyecto de Tesis - Club Match**  
Universidad de las Fuerzas Armadas ESPE  
Carrera: Ingeniería en Tecnologías de la Información

---

## 📄 Licencia

Este proyecto es parte de una investigación académica.

---

## 🎯 Roadmap Futuro

- [ ] Agregar filtros por disponibilidad de días
- [ ] Implementar algoritmo genético para optimización
- [ ] Sistema de feedback post-recomendación
- [ ] Dashboard de visualización de métricas
- [ ] Integración con sistema de autenticación JWT
- [ ] Notificaciones push de nuevas recomendaciones
- [ ] Análisis de sentimiento en descripciones de clubes

---

## 📞 Soporte

Para dudas o problemas, contactar al equipo de desarrollo.

**¡Gracias por usar Club Match IA! 🚀**
