"""
RECOMMENDATION REPOSITORY: Obtención de datos desde PostgreSQL
Responsabilidad: Obtener estudiantes, clubes y catálogos para recomendación
"""

import json
import db_config
from contextlib import contextmanager
from typing import List, Dict, Optional

@contextmanager
def get_db():
    """Context manager para obtener conexión de la BD"""
    conn = db_config.get_connection()
    try:
        yield conn
    finally:
        if conn:
            db_config.release_connection(conn)

class RecommendationRepository:
    """Repositorio para datos de recomendación"""
    
    @staticmethod
    def obtener_estudiante_completo(student_id: int) -> Optional[Dict]:
        """Obtiene un estudiante con todos sus datos para recomendación"""
        try:
            with get_db() as conn:
                cursor = conn.cursor()
                
                # Obtener datos básicos del estudiante
                cursor.execute("""
                    SELECT 
                        s.id,
                        s.semester_number,
                        s.weekly_availability_hours,
                        s.max_parallel_clubs,
                        s.preferred_club_type,
                        c.name as career_name,
                        c.code as career_code,
                        ui.first_name,
                        ui.last_name
                    FROM student s
                    LEFT JOIN career c ON s.career_id = c.id
                    LEFT JOIN user_info ui ON s.user_info_id = ui.id
                    WHERE s.id = %s AND s.record_status = true
                """, (student_id,))
                
                row = cursor.fetchone()
                if not row:
                    cursor.close()
                    return None
                
                student = {
                    'id': row[0],
                    'semester_number': row[1] or 1,
                    'weekly_availability_hours': row[2] or 4,
                    'max_parallel_clubs': row[3] or 2,
                    'preferred_club_type': row[4],
                    'career_name': row[5],
                    'career_code': row[6],
                    'nombre_completo': f"{row[7]} {row[8]}",
                    'intereses': [],
                    'soft_skills': [],
                    'preferred_reasons': []
                }
                
                # Obtener intereses del estudiante
                cursor.execute("""
                    SELECT i.id, i.name, i.description
                    FROM student_interests si
                    JOIN interest i ON si.interest_id = i.id
                    WHERE si.student_id = %s AND i.record_status = true
                """, (student_id,))
                student['intereses'] = [{'id': r[0], 'name': r[1], 'description': r[2]} for r in cursor.fetchall()]
                
                # Obtener soft skills del estudiante
                cursor.execute("""
                    SELECT ss.id, ss.name, ss.description
                    FROM student_soft_skills sss
                    JOIN soft_skill ss ON sss.soft_skill_id = ss.id
                    WHERE sss.student_id = %s AND ss.record_status = true
                """, (student_id,))
                student['soft_skills'] = [{'id': r[0], 'name': r[1], 'description': r[2]} for r in cursor.fetchall()]
                
                # Obtener razones preferidas
                cursor.execute("""
                    SELECT cr.id, cr.name, cr.description
                    FROM student_preferred_reasons spr
                    JOIN club_reason cr ON spr.club_reason_id = cr.id
                    WHERE spr.student_id = %s AND cr.record_status = true
                """, (student_id,))
                student['preferred_reasons'] = [{'id': r[0], 'name': r[1], 'description': r[2]} for r in cursor.fetchall()]
                
                # Obtener respuestas de inteligencias múltiples
                cursor.execute("""
                    SELECT 
                        it.name as intelligence_name,
                        it.code,
                        AVG(sma.score) as avg_score
                    FROM student_mi_answer sma
                    JOIN mi_question mq ON sma.mi_question_id = mq.id
                    JOIN intelligence_type it ON mq.intelligence_type_id = it.id
                    WHERE sma.student_id = %s AND sma.record_status = true
                    GROUP BY it.id, it.name, it.code
                """, (student_id,))
                student['inteligencias_multiples'] = [
                    {'name': r[0], 'code': r[1], 'score': float(r[2])} 
                    for r in cursor.fetchall()
                ]
                
                cursor.close()
                return student
        except Exception as e:
            print(f"✗ Error obteniendo estudiante: {str(e)}")
            raise
    
    @staticmethod
    def obtener_clubes_activos() -> List[Dict]:
        """Obtiene todos los clubes activos con sus características"""
        try:
            with get_db() as conn:
                cursor = conn.cursor()
                
                cursor.execute("""
                    SELECT 
                        c.id,
                        c.name,
                        c.capacity,
                        c.description,
                        ct.name as club_type_name,
                        cp.expected_weekly_commitment_hours,
                        cp.min_semester,
                        cp.max_semester,
                        cp.accepts_beginners,
                        cp.target_careers
                    FROM club c
                    LEFT JOIN club_type ct ON c.club_type_id = ct.id
                    LEFT JOIN club_profile cp ON c.id = cp.club_id
                    WHERE c.record_status = true
                    ORDER BY c.name
                """)
                
                clubs = []
                for row in cursor.fetchall():
                    club = {
                        'id': row[0],
                        'name': row[1],
                        'capacity': row[2],
                        'description': row[3],
                        'club_type': row[4],
                        'weekly_hours': row[5] or 2,
                        'min_semester': row[6] or 1,
                        'max_semester': row[7] or 10,
                        'accepts_beginners': row[8] if row[8] is not None else True,
                        'target_careers': row[9].split(', ') if row[9] else [],
                        'intereses': [],
                        'soft_skills': [],
                        'reasons': [],
                        'miembros_actuales': 0
                    }
                    
                    club_id = row[0]
                    
                    # Obtener intereses del club
                    cursor.execute("""
                        SELECT i.id, i.name
                        FROM club_interests ci
                        JOIN interest i ON ci.interest_id = i.id
                        WHERE ci.club_id = %s AND i.record_status = true
                    """, (club_id,))
                    club['intereses'] = [{'id': r[0], 'name': r[1]} for r in cursor.fetchall()]
                    
                    # Obtener soft skills del club
                    cursor.execute("""
                        SELECT ss.id, ss.name
                        FROM club_soft_skills css
                        JOIN soft_skill ss ON css.soft_skill_id = ss.id
                        WHERE css.club_id = %s AND ss.record_status = true
                    """, (club_id,))
                    club['soft_skills'] = [{'id': r[0], 'name': r[1]} for r in cursor.fetchall()]
                    
                    # Obtener razones del club
                    cursor.execute("""
                        SELECT cr.id, cr.name
                        FROM club_reasons crs
                        JOIN club_reason cr ON crs.club_reason_id = cr.id
                        WHERE crs.club_id = %s AND cr.record_status = true
                    """, (club_id,))
                    club['reasons'] = [{'id': r[0], 'name': r[1]} for r in cursor.fetchall()]
                    
                    # Contar miembros actuales
                    cursor.execute("""
                        SELECT COUNT(*) 
                        FROM club_member 
                        WHERE club_id = %s AND record_status = true
                    """, (club_id,))
                    club['miembros_actuales'] = cursor.fetchone()[0]
                    
                    clubs.append(club)
                
                cursor.close()
                return clubs
        except Exception as e:
            print(f"✗ Error obteniendo clubes: {str(e)}")
            raise
    
    @staticmethod
    def obtener_estudiantes_para_clustering(limit: int = 100) -> List[Dict]:
        """Obtiene múltiples estudiantes para hacer clustering"""
        try:
            with get_db() as conn:
                cursor = conn.cursor()
                
                cursor.execute("""
                    SELECT DISTINCT s.id
                    FROM student s
                    WHERE s.record_status = true
                    LIMIT %s
                """, (limit,))
                
                student_ids = [r[0] for r in cursor.fetchall()]
                cursor.close()
                
                # Obtener datos completos de cada estudiante
                students = []
                for sid in student_ids:
                    student = RecommendationRepository.obtener_estudiante_completo(sid)
                    if student and student['intereses']:  # Solo si tiene datos
                        students.append(student)
                
                return students
        except Exception as e:
            print(f"✗ Error obteniendo estudiantes para clustering: {str(e)}")
            raise
    
    @staticmethod
    def guardar_recomendaciones(student_id: int, recomendaciones: List[Dict]) -> bool:
        """Guarda las recomendaciones generadas en una tabla de log/historial"""
        try:
            with get_db() as conn:
                cursor = conn.cursor()
                
                # Crear tabla si no existe
                cursor.execute("""
                    CREATE TABLE IF NOT EXISTS recommendation_log (
                        id SERIAL PRIMARY KEY,
                        student_id BIGINT NOT NULL,
                        club_id BIGINT NOT NULL,
                        affinity_score FLOAT NOT NULL,
                        rank_position INT NOT NULL,
                        recommended_at TIMESTAMP DEFAULT NOW(),
                        FOREIGN KEY (student_id) REFERENCES student(id),
                        FOREIGN KEY (club_id) REFERENCES club(id)
                    )
                """)
                
                # Insertar recomendaciones
                for i, rec in enumerate(recomendaciones, 1):
                    cursor.execute("""
                        INSERT INTO recommendation_log 
                        (student_id, club_id, affinity_score, rank_position)
                        VALUES (%s, %s, %s, %s)
                    """, (student_id, rec['club_id'], rec['afinidad'], i))
                
                conn.commit()
                cursor.close()
                return True
        except Exception as e:
            print(f"✗ Error guardando recomendaciones: {str(e)}")
            return False
