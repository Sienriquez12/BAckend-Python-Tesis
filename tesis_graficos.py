import pandas as pd
import numpy as np
import random
import matplotlib.pyplot as plt
import seaborn as sns
from sklearn.preprocessing import MultiLabelBinarizer
from sklearn.cluster import KMeans
from sklearn.decomposition import PCA
from copy import deepcopy

# Configuración de estilo de gráficos para que sean visualmente claros
plt.style.use('ggplot')
sns.set_palette("husl")

# ==========================================
# 1. DEFINICIÓN DE CLUBES (ENTIDADES Y REGLAS DE NEGOCIO)
# ==========================================
# FINALIDAD: Definir los "recursos" disponibles y sus reglas (capacidad y foco).
# Esto simula la base de datos de clubes de la universidad.
clubes = [
    {'id_club': 'C_ROBOTICA', 'nombre': 'Club de Robótica', 'capacidad': 10, 'foco': ['Tecnológicos', 'Programación', 'Ingeniería Mecatrónica']},
    {'id_club': 'C_DEBATE', 'nombre': 'Club de Debate', 'capacidad': 15, 'foco': ['Investigación', 'Competencias profesionales', 'Comunicación']},
    {'id_club': 'C_MUSICA', 'nombre': 'Club de Música', 'capacidad': 10, 'foco': ['Arte/Música', 'Culturales']},
    {'id_club': 'C_DESARROLLO', 'nombre': 'Dev Team', 'capacidad': 10, 'foco': ['Tecnológicos', 'Programación', 'Ingeniería en Software', 'Ingeniería en TI']}
]

print("=== 1. DEFINICIÓN DE CLUBES ===")
# Muestra en consola qué clubes existen para validar que se cargaron bien.
for c in clubes:
    print(f"- {c['nombre']} (Capacidad: {c['capacidad']})")
print("\n")

# ==========================================
# 2. FASE 1: GENERACIÓN DE DATOS (SIMULACIÓN DE ENCUESTAS)
# ==========================================
# FINALIDAD: Crear datos sintéticos que imiten las respuestas de los estudiantes
# en el formulario real (Anexo A). Sin esto, no tendríamos qué procesar.
def generar_datos_ficticios(num_estudiantes=50):
    carreras = ['Ingeniería en Software', 'Ingeniería en TI', 'Ingeniería Automotriz', 'Ingeniería Mecatrónica', 'Ingeniería en Telecomunicaciones']
    intereses_posibles = ['Deportivos', 'Culturales', 'Tecnológicos', 'Voluntariado', 'Investigación', 'Arte/Música', 'Programación', 'Comunicación']
    dias_semana = ['Lunes', 'Martes', 'Miércoles', 'Jueves', 'Viernes', 'Sábado']

    datos = []
    for i in range(num_estudiantes):
        perfil = {
            'id_estudiante': i + 1,
            'carrera': random.choice(carreras),
            # Se eligen entre 1 y 3 intereses al azar para dar variedad a los perfiles
            'intereses': random.sample(intereses_posibles, k=random.randint(1, 3)),
            'disponibilidad': random.sample(dias_semana, k=random.randint(1, 4)),
            'promedio_academico': round(random.uniform(7.0, 10.0), 2)
        }
        datos.append(perfil)
    return pd.DataFrame(datos)

# Generamos el DataFrame (tabla de datos) con 50 estudiantes simulados
df_estudiantes = generar_datos_ficticios(50)

print("=== 2. FASE 1: DATOS GENERADOS ===")
print(df_estudiantes.head()) # Muestra las primeras 5 filas para verificación visual
print(f"Total estudiantes: {len(df_estudiantes)}")
print("\n")

# --- GRÁFICO 1: PERFIL DEMOGRÁFICO ---
# FINALIDAD: Entender "quiénes son" nuestros usuarios antes de usar IA.
fig1, axes = plt.subplots(1, 2, figsize=(15, 5))
# Gráfico de barras horizontales para ver qué carrera tiene más estudiantes
sns.countplot(y='carrera', data=df_estudiantes, ax=axes[0], order=df_estudiantes['carrera'].value_counts().index, hue='carrera', palette='viridis')
axes[0].set_title('1. Perfil de Estudiantes (Carrera)')
if axes[0].get_legend(): axes[0].get_legend().remove() # Limpieza visual

# Contamos cuáles son los intereses más repetidos en toda la población
todos_intereses = [int for sublist in df_estudiantes['intereses'] for int in sublist]
pd.Series(todos_intereses).value_counts().sort_values().plot(kind='barh', ax=axes[1], color='teal')
axes[1].set_title('2. Intereses Más Comunes')
plt.tight_layout()
plt.show()

# ==========================================
# 3. FASE 2A: CLUSTERING (AGRUPAMIENTO INTELIGENTE)
# ==========================================
# FINALIDAD: Detectar patrones ocultos. En lugar de ver 50 individuos, la IA ve "grupos" (Clusters).
# Esto ayuda a entender la demanda latente (ej: "hay un gran grupo de artistas este semestre").

# Paso 1: Convertir palabras ("Música", "Deportes") a números (1, 0) para que la IA entienda
mlb = MultiLabelBinarizer()
matriz_intereses = mlb.fit_transform(df_estudiantes['intereses'])

# Paso 2: Aplicar K-Means para encontrar 4 grupos naturales de estudiantes
kmeans = KMeans(n_clusters=4, random_state=42, n_init=10)
grupos = kmeans.fit_predict(matriz_intereses)
df_estudiantes['grupo_cluster'] = grupos # Guardamos a qué grupo pertenece cada uno

print("=== 3. FASE 2A: CLUSTERING ===")
print("Ejemplo de agrupamiento:")
print(df_estudiantes[['id_estudiante', 'intereses', 'grupo_cluster']].head())
print("\n")

# --- GRÁFICO 2: VISUALIZACIÓN DE CLUSTERS (PCA) ---
# FINALIDAD: Como los intereses son multidimensionales, usamos PCA para "aplastarlos" a 2D (X, Y)
# y poder dibujarlos en un plano. Los colores muestran los grupos detectados por la IA.
pca = PCA(n_components=2)
coords = pca.fit_transform(matriz_intereses)
plt.figure(figsize=(10, 6))
sns.scatterplot(x=coords[:,0], y=coords[:,1], hue=grupos, palette='viridis', s=100, alpha=0.8)
plt.title('Fase 2A: Agrupamiento Automático por Intereses (Clustering)')
plt.xlabel('Dimensión Principal 1')
plt.ylabel('Dimensión Principal 2')
plt.legend(title='Grupo Detectado')
plt.grid(True, alpha=0.3)
plt.show()

# ==========================================
# 4. FASE 2B: MATRIZ DE AFINIDAD (CÁLCULO DE COMPATIBILIDAD)
# ==========================================
# FINALIDAD: Calcular numéricamente (Score 0.0 a 1.0) qué tan bien encaja
# CADA estudiante con CADA club. Este es el corazón del sistema de recomendación.

def calcular_afinidad(estudiante, club):
    score = 0.0
    # Regla 1: Coincidencia de intereses (Peso alto: 60%)
    interseccion = set(estudiante['intereses']).intersection(set(club['foco']))
    if len(club['foco']) > 0: score += (len(interseccion) / len(club['foco'])) * 0.6

    # Regla 2: Coincidencia de carrera (Peso medio: 30%)
    if estudiante['carrera'] in club['foco']: score += 0.3

    # Regla 3: Factor aleatorio (10%) para simular preferencias humanas subjetivas
    score += random.uniform(0, 0.1)

    return min(score, 1.0) # Normalizamos para que nunca pase de 1.0 (100%)

# Construimos la matriz gigante de afinidad (Estudiantes x Clubes)
matriz_afinidad = np.zeros((len(df_estudiantes), len(clubes)))
nombres_clubes = [c['nombre'] for c in clubes]

for i, est in df_estudiantes.iterrows():
    for j, club in enumerate(clubes):
        matriz_afinidad[i, j] = calcular_afinidad(est, club)

print("=== 4. FASE 2B: AFINIDAD ===")
print("Matriz de afinidad (primeros 5 estudiantes):")
print(matriz_afinidad[:5]) # Muestra los scores crudos
print("\n")

# --- GRÁFICO 3: MAPA DE CALOR (HEATMAP) ---
# FINALIDAD: Ver visualmente las oportunidades. Los cuadros oscuros indican
# una "pareja perfecta" entre un estudiante y un club.
plt.figure(figsize=(10, 6))
sns.heatmap(matriz_afinidad, cmap='YlGnBu', xticklabels=nombres_clubes, yticklabels=False)
plt.title('Fase 2B: Matriz de Afinidad (¿Quién encaja dónde?)')
plt.ylabel('Estudiantes (1 al 50)')
plt.show()

# ==========================================
# 5. FASE 3: OPTIMIZACIÓN (ALGORITMO GENÉTICO)
# ==========================================
# FINALIDAD: Resolver el rompecabezas. Tenemos los scores, pero los clubes tienen cupos limitados.
# El Algoritmo Genético "evoluciona" soluciones para encontrar la mejor distribución posible.

def fitness(ind):
    """Función de evaluación: Dice qué tan buena es una solución propuesta"""
    score = 0
    cnt = [0]*len(clubes)

    # Sumamos la felicidad total (afinidad) de todos los estudiantes asignados
    for id_est, id_club in enumerate(ind):
        if id_club != -1: # Si el estudiante fue asignado a un club
            score += matriz_afinidad[id_est, id_club]
            cnt[id_club] += 1

    # PENALIZACIÓN: Si un club tiene más gente de la que cabe, restamos puntos fuertemente
    penalizacion = sum([(c - cl['capacidad'])*10 for c, cl in zip(cnt, clubes) if c > cl['capacidad']])
    return score - penalizacion

# Creamos una población inicial de soluciones aleatorias
pob = [[random.randint(-1, len(clubes)-1) for _ in range(50)] for _ in range(50)]
historia = [] # Para guardar el progreso y graficarlo después

print("=== 5. FASE 3: OPTIMIZACIÓN (ALGORITMO GENÉTICO) ===")
for g in range(80): # Ejecutamos la evolución por 80 generaciones
    pob = sorted(pob, key=fitness, reverse=True) # Ordenamos: las mejores soluciones primero
    current_fitness = fitness(pob[0])
    historia.append(current_fitness)

    if g % 20 == 0:
        print(f"Generación {g}: Fitness = {current_fitness:.2f}")

    # Selección y Reproducción (Elitismo + Cruce + Mutación)
    new_pob = pob[:10] # Guardamos a los 10 mejores sin cambios
    while len(new_pob) < 50:
        p1, p2 = random.sample(pob[:20], 2) # Elegimos padres
        cut = random.randint(1, 49) # Punto de corte del ADN
        hijo = p1[:cut] + p2[cut:] # Mezclamos genes
        if random.random() < 0.1: hijo[random.randint(0,49)] = random.randint(-1, 3) # Mutación aleatoria
        new_pob.append(hijo)
    pob = new_pob
print(f"Generación Final: Fitness = {historia[-1]:.2f}\n")


# --- GRÁFICO 4: CURVA DE APRENDIZAJE ---
# FINALIDAD: Demostrar que el algoritmo realmente "aprendió" y mejoró la solución con el tiempo.
plt.figure(figsize=(10, 4))
plt.plot(historia, color='green', linewidth=2)
plt.title('Fase 3: El algoritmo "aprende" y mejora la asignación')
plt.xlabel('Generaciones')
plt.ylabel('Calidad de la Solución (Fitness)')
plt.grid(True)
plt.show()

# ==========================================
# 6. RESULTADOS FINALES
# ==========================================
# FINALIDAD: Presentar la solución ganadora de forma legible.
mejor = pob[0]
res_final = []
for i, c_id in enumerate(mejor):
    res_final.append({
        'Club': clubes[c_id]['nombre'] if c_id != -1 else 'Sin Asignación',
        'Afinidad': matriz_afinidad[i, c_id] if c_id != -1 else 0
    })
df_res = pd.DataFrame(res_final)

print("=== 6. RESULTADOS FINALES ===")
# Muestra cuántos estudiantes quedaron en cada club
print(df_res['Club'].value_counts())

# --- GRÁFICO 5: DISTRIBUCIÓN FINAL ---
# FINALIDAD: Validar visualmente que se respetaron los cupos (línea roja).
plt.figure(figsize=(10, 5))
sns.countplot(x='Club', data=df_res, hue='Club', palette='Set2')
plt.axhline(y=10, color='r', linestyle='--', label='Capacidad Típica (10)')
plt.title('Asignación Final de Estudiantes por Club')
plt.legend()
plt.show()