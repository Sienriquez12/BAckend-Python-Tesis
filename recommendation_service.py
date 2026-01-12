"""
RECOMMENDATION SERVICE: Algoritmo de Inteligencia Artificial
Responsabilidad: Implementar clustering, matriz de afinidad y algoritmo genético
Basado en tesis.py pero con datos reales de PostgreSQL
"""

import numpy as np
import random
from sklearn.preprocessing import MultiLabelBinarizer
from sklearn.cluster import KMeans
from typing import List, Dict, Tuple
from recommendation_repository import RecommendationRepository
import time

class RecommendationService:
    """Servicio de recomendación de clubes usando IA"""
    
    @staticmethod
    def generar_recomendaciones(student_id: int) -> Dict:
        """
        Método principal: Genera recomendaciones para un estudiante
        Sigue el flujo de tesis.py:
        1. Obtención de datos
        2. Clustering (opcional, para contexto)
        3. Matriz de afinidad
        4. Optimización (selección de mejores matches)
        """
        tiempo_inicio = time.time()
        
        print(f"\n{'='*60}")
        print(f"🤖 INICIANDO RECOMENDACIÓN PARA ESTUDIANTE ID: {student_id}")
        print(f"{'='*60}\n")
        
        # ========================================
        # FASE 1: OBTENCIÓN DE DATOS
        # ========================================
        print("📊 FASE 1: Obteniendo datos desde PostgreSQL...")
        
        estudiante = RecommendationRepository.obtener_estudiante_completo(student_id)
        if not estudiante:
            return {
                'error': True,
                'mensaje': f'Estudiante con ID {student_id} no encontrado'
            }
        
        clubes = RecommendationRepository.obtener_clubes_activos()
        if not clubes:
            return {
                'error': True,
                'mensaje': 'No hay clubes disponibles para recomendar'
            }
        
        print(f"✓ Estudiante: {estudiante['nombre_completo']}")
        print(f"✓ Carrera: {estudiante['career_name']}")
        print(f"✓ Intereses: {len(estudiante['intereses'])} registrados")
        print(f"✓ Soft Skills: {len(estudiante['soft_skills'])} registradas")
        print(f"✓ Clubes disponibles: {len(clubes)}")
        
        # Validación: estudiante debe tener intereses
        if not estudiante['intereses']:
            return {
                'error': True,
                'mensaje': 'El estudiante no tiene intereses registrados'
            }
        
        # ========================================
        # FASE 2: CLUSTERING (Contexto de población)
        # ========================================
        print(f"\n{'='*60}")
        print("🔍 FASE 2: Análisis de contexto (Clustering)")
        print(f"{'='*60}")
        
        grupo_cluster = RecommendationService._realizar_clustering(estudiante, student_id)
        print(f"✓ Estudiante asignado al grupo: {grupo_cluster}")
        
        # ========================================
        # FASE 3: MATRIZ DE AFINIDAD
        # ========================================
        print(f"\n{'='*60}")
        print("🧮 FASE 3: Calculando Matriz de Afinidad")
        print(f"{'='*60}")
        
        matriz_afinidad = RecommendationService._calcular_matriz_afinidad(
            estudiante, clubes
        )
        
        print(f"✓ Matriz calculada: {len(clubes)} clubes evaluados")
        print(f"✓ Scores: min={np.min(matriz_afinidad):.2f}, max={np.max(matriz_afinidad):.2f}")
        
        # ========================================
        # FASE 4: SELECCIÓN Y RANKING
        # ========================================
        print(f"\n{'='*60}")
        print("🏆 FASE 4: Generando Ranking de Recomendaciones")
        print(f"{'='*60}")
        
        recomendaciones = RecommendationService._generar_ranking(
            estudiante, clubes, matriz_afinidad
        )
        
        # ========================================
        # RESULTADOS
        # ========================================
        tiempo_total = time.time() - tiempo_inicio
        
        print(f"\n{'='*60}")
        print("✅ RECOMENDACIÓN COMPLETADA")
        print(f"{'='*60}")
        print(f"⏱️  Tiempo total: {tiempo_total:.2f} segundos")
        print(f"📋 Top {min(5, len(recomendaciones))} recomendaciones generadas\n")
        
        # Guardar en BD
        RecommendationRepository.guardar_recomendaciones(student_id, recomendaciones[:10])
        
        return {
            'error': False,
            'estudiante': {
                'id': estudiante['id'],
                'nombre': estudiante['nombre_completo'],
                'carrera': estudiante['career_name'],
                'semestre': estudiante['semester_number'],
                'intereses': [i['name'] for i in estudiante['intereses']],
                'grupo_cluster': grupo_cluster
            },
            'recomendaciones': recomendaciones,
            'metadata': {
                'total_clubes_evaluados': len(clubes),
                'tiempo_procesamiento_segundos': round(tiempo_total, 2),
                'algoritmo': 'Matriz de Afinidad + Filtros Inteligentes'
            }
        }
    
    @staticmethod
    def _realizar_clustering(estudiante: Dict, student_id: int) -> int:
        """
        FASE 2A: Clustering para entender el contexto poblacional
        Similar a tesis.py líneas 71-99
        """
        try:
            # Obtener otros estudiantes para clustering
            estudiantes = RecommendationRepository.obtener_estudiantes_para_clustering(50)
            
            if len(estudiantes) < 4:
                return 0  # No hay suficientes datos para clustering
            
            # Asegurar que el estudiante objetivo esté en la lista
            if not any(e['id'] == student_id for e in estudiantes):
                estudiantes.append(estudiante)
            
            # Convertir intereses a matriz binaria
            mlb = MultiLabelBinarizer()
            intereses_nombres = [[i['name'] for i in e['intereses']] for e in estudiantes]
            matriz_intereses = mlb.fit_transform(intereses_nombres)
            
            # Aplicar K-Means
            n_clusters = min(4, len(estudiantes))
            kmeans = KMeans(n_clusters=n_clusters, random_state=42, n_init=10)
            grupos = kmeans.fit_predict(matriz_intereses)
            
            # Encontrar el grupo del estudiante objetivo
            idx_estudiante = next(i for i, e in enumerate(estudiantes) if e['id'] == student_id)
            return int(grupos[idx_estudiante])
            
        except Exception as e:
            print(f"⚠️  Clustering falló: {str(e)}")
            return 0
    
    @staticmethod
    def _calcular_matriz_afinidad(estudiante: Dict, clubes: List[Dict]) -> np.ndarray:
        """
        FASE 2B: Cálculo de afinidad estudiante-club
        Similar a tesis.py líneas 101-140
        """
        matriz = np.zeros(len(clubes))
        
        for j, club in enumerate(clubes):
            score = RecommendationService._calcular_afinidad_individual(estudiante, club)
            matriz[j] = score
        
        return matriz
    
    @staticmethod
    def _calcular_afinidad_individual(estudiante: Dict, club: Dict) -> float:
        """
        Calcula el score de afinidad entre un estudiante y un club
        Basado en múltiples factores ponderados
        """
        score = 0.0
        
        # FACTOR 1: Coincidencia de Intereses (40%)
        intereses_estudiante = set(i['name'] for i in estudiante['intereses'])
        intereses_club = set(i['name'] for i in club['intereses'])
        
        if intereses_club:
            coincidencias_intereses = len(intereses_estudiante.intersection(intereses_club))
            score += (coincidencias_intereses / max(len(intereses_club), 1)) * 0.40
        
        # FACTOR 2: Coincidencia de Soft Skills (25%)
        skills_estudiante = set(s['name'] for s in estudiante['soft_skills'])
        skills_club = set(s['name'] for s in club['soft_skills'])
        
        if skills_club:
            coincidencias_skills = len(skills_estudiante.intersection(skills_club))
            score += (coincidencias_skills / max(len(skills_club), 1)) * 0.25
        
        # FACTOR 3: Compatibilidad de Carrera (15%)
        if estudiante['career_name'] in club['target_careers']:
            score += 0.15
        
        # FACTOR 4: Razones/Motivaciones (10%)
        reasons_estudiante = set(r['name'] for r in estudiante['preferred_reasons'])
        reasons_club = set(r['name'] for r in club['reasons'])
        
        if reasons_club and reasons_estudiante:
            coincidencias_reasons = len(reasons_estudiante.intersection(reasons_club))
            score += (coincidencias_reasons / max(len(reasons_club), 1)) * 0.10
        
        # FACTOR 5: Semestre compatible (5%)
        if club['min_semester'] <= estudiante['semester_number'] <= club['max_semester']:
            score += 0.05
        
        # FACTOR 6: Disponibilidad horaria (5%)
        if estudiante['weekly_availability_hours'] >= club['weekly_hours']:
            score += 0.05
        
        # PENALIZACIÓN: Club lleno
        if club['miembros_actuales'] >= club['capacity']:
            score *= 0.5  # Reducir score a la mitad si está lleno
        
        return min(score, 1.0)  # Normalizar a máximo 1.0
    
    @staticmethod
    def _generar_ranking(estudiante: Dict, clubes: List[Dict], matriz: np.ndarray) -> List[Dict]:
        """
        FASE 4: Genera ranking final de recomendaciones
        Ordena clubes por afinidad y aplica filtros
        """
        recomendaciones = []
        
        for i, club in enumerate(clubes):
            afinidad = matriz[i]
            
            # Filtro mínimo de afinidad (20%)
            if afinidad < 0.2:
                continue
            
            # Filtro de capacidad (permitir hasta 110% de capacidad)
            if club['miembros_actuales'] >= club['capacity'] * 1.1:
                continue
            
            recomendaciones.append({
                'club_id': club['id'],
                'club_name': club['name'],
                'club_type': club['club_type'],
                'afinidad': round(float(afinidad), 3),
                'afinidad_porcentaje': round(float(afinidad) * 100, 1),
                'capacidad_disponible': club['capacity'] - club['miembros_actuales'],
                'horas_semanales': club['weekly_hours'],
                'descripcion': club['description'],
                'razones_match': RecommendationService._generar_explicacion(estudiante, club, afinidad)
            })
        
        # Ordenar por afinidad descendente
        recomendaciones.sort(key=lambda x: x['afinidad'], reverse=True)
        
        # Limitar a top 10
        return recomendaciones[:10]
    
    @staticmethod
    def _generar_explicacion(estudiante: Dict, club: Dict, afinidad: float) -> List[str]:
        """Genera explicación de por qué se recomienda este club"""
        razones = []
        
        # Intereses compartidos
        intereses_comunes = set(i['name'] for i in estudiante['intereses']).intersection(
            set(i['name'] for i in club['intereses'])
        )
        if intereses_comunes:
            razones.append(f"Comparten intereses: {', '.join(list(intereses_comunes)[:3])}")
        
        # Skills compartidas
        skills_comunes = set(s['name'] for s in estudiante['soft_skills']).intersection(
            set(s['name'] for s in club['soft_skills'])
        )
        if skills_comunes:
            razones.append(f"Desarrollarás: {', '.join(list(skills_comunes)[:2])}")
        
        # Carrera compatible
        if estudiante['career_name'] in club['target_careers']:
            razones.append(f"Orientado a tu carrera: {estudiante['career_name']}")
        
        # Alta afinidad
        if afinidad >= 0.7:
            razones.append("¡Match perfecto! (70%+ compatibilidad)")
        elif afinidad >= 0.5:
            razones.append("Buena compatibilidad (50%+)")
        
        return razones[:4]  # Máximo 4 razones
