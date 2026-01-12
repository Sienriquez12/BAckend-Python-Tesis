
-- Dumping structure for table public.career
CREATE TABLE IF NOT EXISTS "career" (
	"id" SERIAL NOT NULL,
	"code" VARCHAR(50) NOT NULL,
	"created_at" TIMESTAMP NULL DEFAULT NULL,
	"faculty" VARCHAR(200) NULL DEFAULT NULL,
	"name" VARCHAR(200) NOT NULL,
	"record_status" BOOLEAN NULL DEFAULT NULL,
	"updated_at" TIMESTAMP NULL DEFAULT NULL,
	PRIMARY KEY ("id"),
	UNIQUE ("code")
);

-- Dumping data for table public.career: 3 rows
/*!40000 ALTER TABLE "career" DISABLE KEYS */;
INSERT INTO "career" ("id", "code", "created_at", "faculty", "name", "record_status", "updated_at") VALUES
	(1, 'ITIN_SD', '2026-01-06 22:13:03', 'COMPUTACION', 'ITIN', 'true', '2026-01-06 22:13:22'),
	(2, 'BIO_SD', '2026-01-06 22:13:33', 'VIDA', 'BIOTECNOLOGIA', 'true', '2026-01-06 22:14:03'),
	(3, 'AGRO_SD', '2026-01-06 22:13:33', 'VIDA', 'AGROPECUARIA', 'true', '2026-01-06 22:14:03');
/*!40000 ALTER TABLE "career" ENABLE KEYS */;

-- Dumping structure for table public.club
CREATE TABLE IF NOT EXISTS "club" (
	"id" SERIAL NOT NULL,
	"capacity" INTEGER NULL DEFAULT NULL,
	"created_at" TIMESTAMP NULL DEFAULT NULL,
	"description" VARCHAR(2000) NULL DEFAULT NULL,
	"name" VARCHAR(255) NOT NULL,
	"record_status" BOOLEAN NULL DEFAULT NULL,
	"updated_at" TIMESTAMP NULL DEFAULT NULL,
	"whatsapp_group_link" VARCHAR(255) NULL DEFAULT NULL,
	"club_type_id" BIGINT NULL DEFAULT NULL,
	PRIMARY KEY ("id"),
	CONSTRAINT "fk7vh3tldjblrbc36ubfs5wmsm" FOREIGN KEY ("club_type_id") REFERENCES "club_type" ("id") ON UPDATE NO ACTION ON DELETE NO ACTION
);

-- Dumping data for table public.club: 3 rows
/*!40000 ALTER TABLE "club" DISABLE KEYS */;
INSERT INTO "club" ("id", "capacity", "created_at", "description", "name", "record_status", "updated_at", "whatsapp_group_link", "club_type_id") VALUES
	(1, 150, '2026-01-07 02:27:39.569648', 'Club deportivo enfocado en fútbol amateur, prueba', 'Club Atlético Central', 'true', '2026-01-12 19:08:50.706909', 'https://chat.whatsapp.com/AAAA1111', 1),
	(2, 80, '2026-01-07 02:27:39.569648', 'Club social y recreativo del barrio', 'Club Social Unión', 'true', '2026-01-07 02:27:39.569648', 'https://chat.whatsapp.com/BBBB2222', 4),
	(4, 50, '2026-01-07 02:27:39.569648', 'Club privado de lectura y café', 'Club Literario Aurora', 'true', '2026-01-07 02:27:39.569648', 'https://chat.whatsapp.com/DDDD4444', 3);
/*!40000 ALTER TABLE "club" ENABLE KEYS */;

-- Dumping structure for table public.club_interests
CREATE TABLE IF NOT EXISTS "club_interests" (
	"club_id" BIGINT NOT NULL,
	"interest_id" BIGINT NOT NULL,
	PRIMARY KEY ("club_id", "interest_id"),
	CONSTRAINT "fk1s7yo5ejdw14d3906s0c6d674" FOREIGN KEY ("club_id") REFERENCES "club" ("id") ON UPDATE NO ACTION ON DELETE NO ACTION,
	CONSTRAINT "fkdts8eb3qaxg6p4klyb66akx4" FOREIGN KEY ("interest_id") REFERENCES "interest" ("id") ON UPDATE NO ACTION ON DELETE NO ACTION
);

-- Dumping data for table public.club_interests: -1 rows
/*!40000 ALTER TABLE "club_interests" DISABLE KEYS */;
INSERT INTO "club_interests" ("club_id", "interest_id") VALUES
	(1, 1),
	(1, 2),
	(1, 3),
	(1, 4),
	(1, 5),
	(2, 22),
	(2, 23),
	(2, 24),
	(2, 27),
	(2, 28),
	(2, 30),
	(4, 18),
	(4, 20),
	(4, 21),
	(4, 25),
	(4, 26);
/*!40000 ALTER TABLE "club_interests" ENABLE KEYS */;

-- Dumping structure for table public.club_member
CREATE TABLE IF NOT EXISTS "club_member" (
	"id" SERIAL NOT NULL,
	"created_at" TIMESTAMP NULL DEFAULT NULL,
	"record_status" BOOLEAN NULL DEFAULT NULL,
	"updated_at" TIMESTAMP NULL DEFAULT NULL,
	"club_id" BIGINT NOT NULL,
	"student_id" BIGINT NOT NULL,
	PRIMARY KEY ("id"),
	UNIQUE ("club_id", "student_id"),
	CONSTRAINT "fk5puo85vt75pvoe4k1ot4b7a25" FOREIGN KEY ("student_id") REFERENCES "student" ("id") ON UPDATE NO ACTION ON DELETE NO ACTION,
	CONSTRAINT "fkf6tl19ih8acrmheidn4xos2tx" FOREIGN KEY ("club_id") REFERENCES "club" ("id") ON UPDATE NO ACTION ON DELETE NO ACTION
);

-- Dumping data for table public.club_member: -1 rows
/*!40000 ALTER TABLE "club_member" DISABLE KEYS */;
INSERT INTO "club_member" ("id", "created_at", "record_status", "updated_at", "club_id", "student_id") VALUES
	(1, '2026-01-10 20:50:36.521865', 'true', '2026-01-10 20:50:36.521865', 1, 1);
/*!40000 ALTER TABLE "club_member" ENABLE KEYS */;

-- Dumping structure for table public.club_profile
CREATE TABLE IF NOT EXISTS "club_profile" (
	"id" SERIAL NOT NULL,
	"accepts_beginners" BOOLEAN NULL DEFAULT NULL,
	"club_type" VARCHAR(100) NULL DEFAULT NULL,
	"created_at" TIMESTAMP NULL DEFAULT NULL,
	"expected_weekly_commitment_hours" INTEGER NULL DEFAULT NULL,
	"is_active_for_recommendation" BOOLEAN NULL DEFAULT NULL,
	"max_semester" INTEGER NULL DEFAULT NULL,
	"min_semester" INTEGER NULL DEFAULT NULL,
	"target_careers" VARCHAR(500) NULL DEFAULT NULL,
	"updated_at" TIMESTAMP NULL DEFAULT NULL,
	"club_id" BIGINT NOT NULL,
	PRIMARY KEY ("id"),
	UNIQUE ("club_id"),
	CONSTRAINT "fktg517xhfsms9oreser10s50e2" FOREIGN KEY ("club_id") REFERENCES "club" ("id") ON UPDATE NO ACTION ON DELETE NO ACTION
);

-- Dumping data for table public.club_profile: -1 rows
/*!40000 ALTER TABLE "club_profile" DISABLE KEYS */;
INSERT INTO "club_profile" ("id", "accepts_beginners", "club_type", "created_at", "expected_weekly_commitment_hours", "is_active_for_recommendation", "max_semester", "min_semester", "target_careers", "updated_at", "club_id") VALUES
	(1, 'true', 'DEPORTIVO', '2026-01-11 01:21:15.542783', 6, 'true', 10, 1, 'ITIN, BIOTECNOLOGIA, AGROPECUARIA', '2026-01-11 01:21:15.542783', 1),
	(2, 'true', 'SOCIAL', '2026-01-11 01:21:15.813289', 3, 'true', 10, 1, 'ITIN, BIOTECNOLOGIA, AGROPECUARIA', '2026-01-11 01:21:15.813289', 2),
	(3, 'true', 'CULTURAL', '2026-01-11 01:21:16.023888', 2, 'true', 10, 1, 'ITIN, BIOTECNOLOGIA, AGROPECUARIA', '2026-01-11 01:21:16.023888', 4);
/*!40000 ALTER TABLE "club_profile" ENABLE KEYS */;

-- Dumping structure for table public.club_reason
CREATE TABLE IF NOT EXISTS "club_reason" (
	"id" SERIAL NOT NULL,
	"created_at" TIMESTAMP NULL DEFAULT NULL,
	"description" VARCHAR(255) NULL DEFAULT NULL,
	"name" VARCHAR(255) NOT NULL,
	"record_status" BOOLEAN NULL DEFAULT NULL,
	"updated_at" TIMESTAMP NULL DEFAULT NULL,
	PRIMARY KEY ("id"),
	UNIQUE ("name")
);

-- Dumping data for table public.club_reason: -1 rows
/*!40000 ALTER TABLE "club_reason" DISABLE KEYS */;
INSERT INTO "club_reason" ("id", "created_at", "description", "name", "record_status", "updated_at") VALUES
	(1, '2026-01-11 00:47:20.319896', 'El estudiante desea complementar su formación académica mediante actividades relacionadas con su carrera.', 'Interés académico', 'true', '2026-01-11 00:47:20.319896'),
	(2, '2026-01-11 00:47:20.319896', 'Busca mejorar habilidades personales como liderazgo, comunicación y trabajo en equipo.', 'Desarrollo personal', 'true', '2026-01-11 00:47:20.319896'),
	(3, '2026-01-11 00:47:20.319896', 'Tiene afinidad por actividades físicas y deportivas que ofrece el club.', 'Interés deportivo', 'true', '2026-01-11 00:47:20.319896'),
	(4, '2026-01-11 00:47:20.319896', 'Desea participar por gusto personal o afinidad con las actividades del club.', 'Hobby o pasatiempo', 'true', '2026-01-11 00:47:20.319896'),
	(5, '2026-01-11 00:47:20.319896', 'Quiere ampliar su círculo social y fortalecer sus relaciones interpersonales.', 'Mejorar habilidades sociales', 'true', '2026-01-11 00:47:20.319896'),
	(6, '2026-01-11 00:47:20.319896', 'Busca adquirir experiencia práctica que aporte a su perfil profesional.', 'Experiencia profesional', 'true', '2026-01-11 00:47:20.319896'),
	(7, '2026-01-11 00:47:20.319896', 'Fue recomendado por docentes o autoridades académicas para integrarse al club.', 'Recomendación académica', 'true', '2026-01-11 00:47:20.319896'),
	(8, '2026-01-11 00:47:20.319896', 'Desea mejorar su bienestar físico, mental y emocional mediante actividades recreativas o deportivas.', 'Bienestar y salud', 'true', '2026-01-11 00:47:20.319896'),
	(9, '2026-01-11 00:47:20.319896', 'Le atraen las actividades culturales, artísticas o literarias del club.', 'Interés cultural', 'true', '2026-01-11 00:47:20.319896'),
	(10, '2026-01-11 00:47:20.319896', 'Tiene interés en participar en proyectos sociales y comunitarios.', 'Compromiso social', 'true', '2026-01-11 00:47:20.319896'),
	(11, '2026-01-11 00:47:20.319896', 'Desea desarrollar conocimientos en tecnología, ciencia o innovación.', 'Innovación y tecnología', 'true', '2026-01-11 00:47:20.319896'),
	(12, '2026-01-11 00:47:20.319896', 'Quiere representar a la institución en eventos, competencias o actividades externas.', 'Representación institucional', 'true', '2026-01-11 00:47:20.319896');
/*!40000 ALTER TABLE "club_reason" ENABLE KEYS */;

-- Dumping structure for table public.club_reasons
CREATE TABLE IF NOT EXISTS "club_reasons" (
	"club_id" BIGINT NOT NULL,
	"club_reason_id" BIGINT NOT NULL,
	PRIMARY KEY ("club_id", "club_reason_id"),
	CONSTRAINT "fk5ypo5ykt53bi6vot9jbn27b3s" FOREIGN KEY ("club_reason_id") REFERENCES "club_reason" ("id") ON UPDATE NO ACTION ON DELETE NO ACTION,
	CONSTRAINT "fkds8frvn43ghpgd8exryohx6mn" FOREIGN KEY ("club_id") REFERENCES "club" ("id") ON UPDATE NO ACTION ON DELETE NO ACTION
);

-- Dumping data for table public.club_reasons: -1 rows
/*!40000 ALTER TABLE "club_reasons" DISABLE KEYS */;
INSERT INTO "club_reasons" ("club_id", "club_reason_id") VALUES
	(1, 2),
	(1, 3),
	(1, 8),
	(1, 12),
	(2, 2),
	(2, 5),
	(2, 10),
	(4, 1),
	(4, 2),
	(4, 4),
	(4, 9),
	(4, 11);
/*!40000 ALTER TABLE "club_reasons" ENABLE KEYS */;

-- Dumping structure for table public.club_soft_skills
CREATE TABLE IF NOT EXISTS "club_soft_skills" (
	"club_id" BIGINT NOT NULL,
	"soft_skill_id" BIGINT NOT NULL,
	PRIMARY KEY ("club_id", "soft_skill_id"),
	CONSTRAINT "fk1bfk0s325xgosb8j7m9yri8im" FOREIGN KEY ("club_id") REFERENCES "club" ("id") ON UPDATE NO ACTION ON DELETE NO ACTION,
	CONSTRAINT "fkg5a2ps49xnwcucmmwk1dvidyu" FOREIGN KEY ("soft_skill_id") REFERENCES "soft_skill" ("id") ON UPDATE NO ACTION ON DELETE NO ACTION
);

-- Dumping data for table public.club_soft_skills: -1 rows
/*!40000 ALTER TABLE "club_soft_skills" DISABLE KEYS */;
INSERT INTO "club_soft_skills" ("club_id", "soft_skill_id") VALUES
	(1, 1),
	(1, 3),
	(1, 4),
	(1, 9),
	(1, 11),
	(1, 13),
	(1, 14),
	(1, 16),
	(1, 17),
	(1, 23),
	(2, 2),
	(2, 5),
	(2, 6),
	(2, 12),
	(2, 15),
	(2, 18),
	(2, 20),
	(2, 26),
	(2, 27),
	(2, 30),
	(4, 2),
	(4, 7),
	(4, 8),
	(4, 19),
	(4, 21),
	(4, 22),
	(4, 24),
	(4, 25),
	(4, 28),
	(4, 29);
/*!40000 ALTER TABLE "club_soft_skills" ENABLE KEYS */;

-- Dumping structure for table public.club_type
CREATE TABLE IF NOT EXISTS "club_type" (
	"id" SERIAL NOT NULL,
	"created_at" TIMESTAMP NULL DEFAULT NULL,
	"description" VARCHAR(1000) NULL DEFAULT NULL,
	"name" VARCHAR(255) NOT NULL,
	"order_index" INTEGER NULL DEFAULT NULL,
	"record_status" BOOLEAN NULL DEFAULT NULL,
	"updated_at" TIMESTAMP NULL DEFAULT NULL,
	PRIMARY KEY ("id"),
	UNIQUE ("name")
);

-- Dumping data for table public.club_type: -1 rows
/*!40000 ALTER TABLE "club_type" DISABLE KEYS */;
INSERT INTO "club_type" ("id", "created_at", "description", "name", "order_index", "record_status", "updated_at") VALUES
	(1, '2026-01-11 03:26:01.844893', 'Clubes enfocados en la actividad física y competencia deportiva como fútbol, básquet, atletismo, natación, entre otros.', 'Deportivo', 1, 'true', '2026-01-11 03:26:01.844893'),
	(2, '2026-01-11 03:26:01.844893', 'Clubes orientados al refuerzo académico en áreas como programación, robótica, matemáticas, investigación científica y otras disciplinas.', 'Académico', 2, 'true', '2026-01-11 03:26:01.844893'),
	(3, '2026-01-11 03:26:01.844893', 'Clubes dedicados a actividades culturales y artísticas como teatro, música, danza, lectura, fotografía y expresión creativa.', 'Cultural y artístico', 3, 'true', '2026-01-11 03:26:01.844893'),
	(4, '2026-01-11 03:26:01.844893', 'Clubes enfocados en ayuda comunitaria, medio ambiente, derechos humanos y proyectos con impacto social.', 'Social y voluntariado', 4, 'true', '2026-01-11 03:26:01.844893'),
	(5, '2026-01-11 03:26:01.844893', 'Clubes orientados al desarrollo de habilidades en tecnología como inteligencia artificial, ciberseguridad, desarrollo de software y electrónica.', 'Tecnológico', 5, 'true', '2026-01-11 03:26:01.844893'),
	(6, '2026-01-11 03:26:01.844893', 'Clubes enfocados en negocios, creación de startups, innovación, liderazgo estudiantil y desarrollo empresarial.', 'Emprendimiento y liderazgo', 6, 'true', '2026-01-11 03:26:01.844893'),
	(7, '2026-01-11 03:26:01.844893', 'Clubes orientados al entretenimiento y hobbies como ajedrez, videojuegos, debates y actividades recreativas.', 'Recreativo', 7, 'true', '2026-01-11 03:26:01.844893');
/*!40000 ALTER TABLE "club_type" ENABLE KEYS */;

-- Dumping structure for table public.event
CREATE TABLE IF NOT EXISTS "event" (
	"id" SERIAL NOT NULL,
	"created_at" TIMESTAMP NULL DEFAULT NULL,
	"description" VARCHAR(2000) NULL DEFAULT NULL,
	"end_at" TIMESTAMP NULL DEFAULT NULL,
	"location" VARCHAR(255) NULL DEFAULT NULL,
	"record_status" BOOLEAN NULL DEFAULT NULL,
	"start_at" TIMESTAMP NOT NULL,
	"title" VARCHAR(255) NOT NULL,
	"updated_at" TIMESTAMP NULL DEFAULT NULL,
	"virtual_link" VARCHAR(500) NULL DEFAULT NULL,
	"club_id" BIGINT NOT NULL,
	"created_by_user_info_id" BIGINT NOT NULL,
	PRIMARY KEY ("id"),
	CONSTRAINT "fk2ugnbv1rnlmwcwjquffqp1m8" FOREIGN KEY ("created_by_user_info_id") REFERENCES "user_info" ("id") ON UPDATE NO ACTION ON DELETE NO ACTION,
	CONSTRAINT "fkge5xi5nf69096gtcjwjtup8wm" FOREIGN KEY ("club_id") REFERENCES "club" ("id") ON UPDATE NO ACTION ON DELETE NO ACTION
);

-- Dumping data for table public.event: -1 rows
/*!40000 ALTER TABLE "event" DISABLE KEYS */;
INSERT INTO "event" ("id", "created_at", "description", "end_at", "location", "record_status", "start_at", "title", "updated_at", "virtual_link", "club_id", "created_by_user_info_id") VALUES
	(1, '2026-01-07 21:37:15.46582', 'Reunion para definir la plantilla de futbol que nos va a representar en los juegos universitarios provinciales', '2025-12-23 03:49:54.812', 'Cancha de Futbol', 'true', '2025-12-23 03:49:54.812', 'Reunion para revisar plantilla de futbol', '2026-01-07 21:37:15.46582', 'https://www.conmebol.com/noticias/reunion-de-la-subcomision-de-clubes-de-la-conmebol/', 1, 1);
/*!40000 ALTER TABLE "event" ENABLE KEYS */;

-- Dumping structure for table public.intelligence_type
CREATE TABLE IF NOT EXISTS "intelligence_type" (
	"id" SERIAL NOT NULL,
	"code" VARCHAR(50) NULL DEFAULT NULL,
	"created_at" TIMESTAMP NULL DEFAULT NULL,
	"description" VARCHAR(1000) NULL DEFAULT NULL,
	"name" VARCHAR(150) NOT NULL,
	"record_status" BOOLEAN NULL DEFAULT NULL,
	"updated_at" TIMESTAMP NULL DEFAULT NULL,
	PRIMARY KEY ("id"),
	UNIQUE ("code")
);

-- Dumping data for table public.intelligence_type: -1 rows
/*!40000 ALTER TABLE "intelligence_type" DISABLE KEYS */;
INSERT INTO "intelligence_type" ("id", "code", "created_at", "description", "name", "record_status", "updated_at") VALUES
	(1, 'LINGUISTIC', '2026-01-07 02:22:04.162645', 'Facilidad con las palabras y el lenguaje', 'Lingüística', 'true', NULL),
	(2, 'LOGICAL', '2026-01-07 02:22:04.162645', 'Habilidad para el razonamiento lógico y los números', 'Lógico-matemática', 'true', NULL),
	(3, 'VISUAL', '2026-01-07 02:22:04.162645', 'Pensar en imágenes y espacios', 'Viso-espacial', 'true', NULL),
	(4, 'MUSICAL', '2026-01-07 02:22:04.162645', 'Sensibilidad al ritmo y al sonido', 'Musical', 'true', NULL),
	(5, 'BODILY', '2026-01-07 02:22:04.162645', 'Habilidad con el cuerpo y el movimiento', 'Corporal-cinestésica', 'true', NULL),
	(6, 'INTERPERSONAL', '2026-01-07 02:22:04.162645', 'Capacidad de entender y relacionarse con otros', 'Interpersonal', 'true', NULL),
	(7, 'INTRAPERSONAL', '2026-01-07 02:22:04.162645', 'Capacidad de autoconocimiento y gestión emocional', 'Intrapersonal', 'true', NULL),
	(8, 'NATURALIST', '2026-01-07 02:22:04.162645', 'Comprensión del entorno natural', 'Naturalista', 'true', NULL);
/*!40000 ALTER TABLE "intelligence_type" ENABLE KEYS */;

-- Dumping structure for table public.interest
CREATE TABLE IF NOT EXISTS "interest" (
	"id" SERIAL NOT NULL,
	"created_at" TIMESTAMP NULL DEFAULT NULL,
	"description" VARCHAR(255) NULL DEFAULT NULL,
	"name" VARCHAR(255) NOT NULL,
	"record_status" BOOLEAN NULL DEFAULT NULL,
	"updated_at" TIMESTAMP NULL DEFAULT NULL,
	PRIMARY KEY ("id"),
	UNIQUE ("name")
);

-- Dumping data for table public.interest: -1 rows
/*!40000 ALTER TABLE "interest" DISABLE KEYS */;
INSERT INTO "interest" ("id", "created_at", "description", "name", "record_status", "updated_at") VALUES
	(1, '2026-01-10 03:23:28.56763', 'Interés en participar en clubes y actividades relacionadas con el fútbol.', 'Fútbol', 'true', '2026-01-10 03:23:28.56763'),
	(2, '2026-01-10 03:23:28.56763', 'Interés en clubes de baloncesto y entrenamientos deportivos.', 'Baloncesto', 'true', '2026-01-10 03:23:28.56763'),
	(3, '2026-01-10 03:23:28.56763', 'Participación en clubes de voleibol recreativo o competitivo.', 'Voleibol', 'true', '2026-01-10 03:23:28.56763'),
	(4, '2026-01-10 03:23:28.56763', 'Interés en clubes de atletismo y entrenamiento físico.', 'Atletismo', 'true', '2026-01-10 03:23:28.56763'),
	(5, '2026-01-10 03:23:28.56763', 'Participación en clubes de natación y actividades acuáticas.', 'Natación', 'true', '2026-01-10 03:23:28.56763'),
	(6, '2026-01-10 03:23:28.56763', 'Interés en clubes de ajedrez y desarrollo del pensamiento lógico.', 'Ajedrez', 'true', '2026-01-10 03:23:28.56763'),
	(7, '2026-01-10 03:23:28.56763', 'Participación en clubes de robótica e innovación tecnológica.', 'Robótica', 'true', '2026-01-10 03:23:28.56763'),
	(8, '2026-01-10 03:23:28.56763', 'Interés en clubes de programación y desarrollo de software.', 'Programación', 'true', '2026-01-10 03:23:28.56763'),
	(9, '2026-01-10 03:23:28.56763', 'Interés en clubes enfocados en seguridad informática.', 'Ciberseguridad', 'true', '2026-01-10 03:23:28.56763'),
	(10, '2026-01-10 03:23:28.56763', 'Participación en clubes de inteligencia artificial y ciencia de datos.', 'Inteligencia Artificial', 'true', '2026-01-10 03:23:28.56763'),
	(11, '2026-01-10 03:23:28.56763', 'Interés en clubes de electrónica y sistemas embebidos.', 'Electrónica', 'true', '2026-01-10 03:23:28.56763'),
	(12, '2026-01-10 03:23:28.56763', 'Participación en clubes de emprendimiento e innovación empresarial.', 'Emprendimiento', 'true', '2026-01-10 03:23:28.56763'),
	(13, '2026-01-10 03:23:28.56763', 'Interés en clubes de marketing digital y redes sociales.', 'Marketing Digital', 'true', '2026-01-10 03:23:28.56763'),
	(14, '2026-01-10 03:23:28.56763', 'Participación en clubes de fotografía artística y técnica.', 'Fotografía', 'true', '2026-01-10 03:23:28.56763'),
	(15, '2026-01-10 03:23:28.56763', 'Interés en clubes de video, cine y edición audiovisual.', 'Producción Audiovisual', 'true', '2026-01-10 03:23:28.56763'),
	(16, '2026-01-10 03:23:28.56763', 'Participación en clubes musicales y grupos instrumentales.', 'Música', 'true', '2026-01-10 03:23:28.56763'),
	(17, '2026-01-10 03:23:28.56763', 'Interés en clubes de canto y técnica vocal.', 'Canto', 'true', '2026-01-10 03:23:28.56763'),
	(18, '2026-01-10 03:23:28.56763', 'Participación en clubes de teatro y artes escénicas.', 'Teatro', 'true', '2026-01-10 03:23:28.56763'),
	(19, '2026-01-10 03:23:28.56763', 'Interés en clubes de danza moderna, folclórica o contemporánea.', 'Danza', 'true', '2026-01-10 03:23:28.56763'),
	(20, '2026-01-10 03:23:28.56763', 'Participación en clubes de lectura y análisis literario.', 'Lectura', 'true', '2026-01-10 03:23:28.56763'),
	(21, '2026-01-10 03:23:28.56763', 'Interés en clubes de escritura creativa y académica.', 'Escritura', 'true', '2026-01-10 03:23:28.56763'),
	(22, '2026-01-10 03:23:28.56763', 'Participación en clubes de voluntariado y acción social.', 'Voluntariado', 'true', '2026-01-10 03:23:28.56763'),
	(23, '2026-01-10 03:23:28.56763', 'Interés en clubes de protección ambiental y sostenibilidad.', 'Medio Ambiente', 'true', '2026-01-10 03:23:28.56763'),
	(24, '2026-01-10 03:23:28.56763', 'Participación en clubes de promoción de derechos humanos.', 'Derechos Humanos', 'true', '2026-01-10 03:23:28.56763'),
	(25, '2026-01-10 03:23:28.56763', 'Interés en clubes de debate y oratoria.', 'Debate', 'true', '2026-01-10 03:23:28.56763'),
	(26, '2026-01-10 03:23:28.56763', 'Participación en clubes de investigación académica.', 'Investigación Científica', 'true', '2026-01-10 03:23:28.56763'),
	(27, '2026-01-10 03:23:28.56763', 'Interés en clubes de innovación con impacto social.', 'Innovación Social', 'true', '2026-01-10 03:23:28.56763'),
	(28, '2026-01-10 03:23:28.56763', 'Participación en clubes de bienestar físico y mental.', 'Salud y Bienestar', 'true', '2026-01-10 03:23:28.56763'),
	(29, '2026-01-10 03:23:28.56763', 'Interés en clubes de formación en primeros auxilios.', 'Primeros Auxilios', 'true', '2026-01-10 03:23:28.56763'),
	(30, '2026-01-10 03:23:28.56763', 'Participación en clubes de liderazgo y desarrollo personal.', 'Liderazgo', 'true', '2026-01-10 03:23:28.56763');
/*!40000 ALTER TABLE "interest" ENABLE KEYS */;

-- Dumping structure for table public.llm_interaction
CREATE TABLE IF NOT EXISTS "llm_interaction" (
	"id" SERIAL NOT NULL,
	"created_at" TIMESTAMP NULL DEFAULT NULL,
	"model" VARCHAR(100) NULL DEFAULT NULL,
	"prompt" TEXT NULL DEFAULT NULL,
	"response" TEXT NULL DEFAULT NULL,
	"student_survey_id" BIGINT NULL DEFAULT NULL,
	"user_info_id" BIGINT NULL DEFAULT NULL,
	PRIMARY KEY ("id"),
	CONSTRAINT "fk4m66je58q7cuxmtaty5j5xwxo" FOREIGN KEY ("student_survey_id") REFERENCES "student_survey" ("id") ON UPDATE NO ACTION ON DELETE NO ACTION,
	CONSTRAINT "fkj6fc1b4w1x560ngnt0aet06iq" FOREIGN KEY ("user_info_id") REFERENCES "user_info" ("id") ON UPDATE NO ACTION ON DELETE NO ACTION
);

-- Dumping structure for table public.meeting_format
CREATE TABLE IF NOT EXISTS "meeting_format" (
	"id" SERIAL NOT NULL,
	"color" VARCHAR(20) NULL DEFAULT NULL,
	"created_at" TIMESTAMP NULL DEFAULT NULL,
	"description" VARCHAR(500) NULL DEFAULT NULL,
	"icon" VARCHAR(100) NULL DEFAULT NULL,
	"is_default" BOOLEAN NULL DEFAULT NULL,
	"name" VARCHAR(255) NOT NULL,
	"order_index" INTEGER NULL DEFAULT NULL,
	"record_status" BOOLEAN NULL DEFAULT NULL,
	"updated_at" TIMESTAMP NULL DEFAULT NULL,
	PRIMARY KEY ("id"),
	UNIQUE ("name")
);

-- Dumping data for table public.meeting_format: -1 rows
/*!40000 ALTER TABLE "meeting_format" DISABLE KEYS */;
/*!40000 ALTER TABLE "meeting_format" ENABLE KEYS */;

-- Dumping structure for table public.mi_question
CREATE TABLE IF NOT EXISTS "mi_question" (
	"id" SERIAL NOT NULL,
	"code" VARCHAR(100) NULL DEFAULT NULL,
	"created_at" TIMESTAMP NULL DEFAULT NULL,
	"order_index" INTEGER NULL DEFAULT NULL,
	"record_status" BOOLEAN NULL DEFAULT NULL,
	"text" VARCHAR(2000) NULL DEFAULT NULL,
	"updated_at" TIMESTAMP NULL DEFAULT NULL,
	"intelligence_type_id" BIGINT NULL DEFAULT NULL,
	PRIMARY KEY ("id"),
	UNIQUE ("code"),
	CONSTRAINT "fke28dlg2l4o5arlwlpq06m64l5" FOREIGN KEY ("intelligence_type_id") REFERENCES "intelligence_type" ("id") ON UPDATE NO ACTION ON DELETE NO ACTION
);

-- Dumping data for table public.mi_question: -1 rows
/*!40000 ALTER TABLE "mi_question" DISABLE KEYS */;
INSERT INTO "mi_question" ("id", "code", "created_at", "order_index", "record_status", "text", "updated_at", "intelligence_type_id") VALUES
	(1, 'LING_1', '2026-01-07 02:22:04.573031', 1, 'true', 'Me siento cómodo expresando ideas por escrito o hablando en público.', NULL, 1),
	(2, 'LING_2', '2026-01-07 02:22:04.573031', 2, 'true', 'Disfruto leer y escribir historias o ensayos.', NULL, 1),
	(3, 'LOG_1', '2026-01-07 02:22:04.573031', 1, 'true', 'Me gusta resolver rompecabezas y problemas de lógica.', NULL, 2),
	(4, 'LOG_2', '2026-01-07 02:22:04.573031', 2, 'true', 'Me resulta sencillo comprender conceptos matemáticos.', NULL, 2),
	(5, 'VIS_1', '2026-01-07 02:22:04.573031', 1, 'true', 'Puedo imaginar cómo se verá un objeto desde diferentes ángulos.', NULL, 3),
	(6, 'VIS_2', '2026-01-07 02:22:04.573031', 2, 'true', 'Disfruto dibujar, diseñar o trabajar con imágenes.', NULL, 3),
	(7, 'MUS_1', '2026-01-07 02:22:04.573031', 1, 'true', 'Me acuerdo fácilmente de melodías y ritmos.', NULL, 4),
	(8, 'MUS_2', '2026-01-07 02:22:04.573031', 2, 'true', 'Me gusta tocar instrumentos o cantar.', NULL, 4),
	(9, 'BOD_1', '2026-01-07 02:22:04.573031', 1, 'true', 'Aprendo mejor cuando hago actividades prácticas y en movimiento.', NULL, 5),
	(10, 'BOD_2', '2026-01-07 02:22:04.573031', 2, 'true', 'Me siento cómodo usando mi cuerpo para expresarme (baile, deporte).', NULL, 5),
	(11, 'INTP_1', '2026-01-07 02:22:04.573031', 1, 'true', 'Me resulta fácil entender las emociones y necesidades de otras personas.', NULL, 6),
	(12, 'INTP_2', '2026-01-07 02:22:04.573031', 2, 'true', 'Disfruto trabajar en equipo y liderar actividades sociales.', NULL, 6),
	(13, 'INTR_1', '2026-01-07 02:22:04.573031', 1, 'true', 'Puedo identificar mis emociones y cómo me afectan.', NULL, 7),
	(14, 'INTR_2', '2026-01-07 02:22:04.573031', 2, 'true', 'Me gusta reflexionar sobre mis decisiones y metas personales.', NULL, 7),
	(15, 'NAT_1', '2026-01-07 02:22:04.573031', 1, 'true', 'Disfruto observar y clasificar plantas, animales o el entorno natural.', NULL, 8),
	(16, 'NAT_2', '2026-01-07 02:22:04.573031', 2, 'true', 'Me interesa aprender sobre ecología y conservación.', NULL, 8);
/*!40000 ALTER TABLE "mi_question" ENABLE KEYS */;

-- Dumping structure for table public.soft_skill
CREATE TABLE IF NOT EXISTS "soft_skill" (
	"id" SERIAL NOT NULL,
	"created_at" TIMESTAMP NULL DEFAULT NULL,
	"description" VARCHAR(255) NULL DEFAULT NULL,
	"name" VARCHAR(255) NOT NULL,
	"record_status" BOOLEAN NULL DEFAULT NULL,
	"updated_at" TIMESTAMP NULL DEFAULT NULL,
	PRIMARY KEY ("id"),
	UNIQUE ("name")
);

-- Dumping data for table public.soft_skill: 30 rows
/*!40000 ALTER TABLE "soft_skill" DISABLE KEYS */;
INSERT INTO "soft_skill" ("id", "created_at", "description", "name", "record_status", "updated_at") VALUES
	(1, '2026-01-06 22:26:40', 'Capacidad para colaborar eficazmente con otros miembros del club', 'Trabajo en equipo', 'true', '2026-01-06 22:27:12'),
	(2, '2026-01-06 22:26:41', 'Habilidad para expresar ideas de forma clara y respetuosa', 'Comunicación efectiva', 'true', '2026-01-06 22:27:13'),
	(3, '2026-01-06 22:26:42', 'Capacidad de guiar y motivar a otros', 'Liderazgo', 'true', '2026-01-06 22:27:13'),
	(4, '2026-01-06 22:26:43', 'Cumplimiento de tareas y compromisos asignados', 'Responsabilidad', 'true', '2026-01-06 22:27:14'),
	(5, '2026-01-06 22:26:43', 'Capacidad de comprender y respetar los sentimientos de otros', 'Empatía', 'true', '2026-01-06 22:27:15'),
	(6, '2026-01-06 22:26:44', 'Habilidad para manejar desacuerdos de forma constructiva', 'Resolución de conflictos', 'true', '2026-01-06 22:27:16'),
	(7, '2026-01-06 22:26:45', 'Capacidad para analizar situaciones y tomar decisiones acertadas', 'Pensamiento crítico', 'true', '2026-01-06 22:27:16'),
	(8, '2026-01-06 22:26:46', 'Habilidad para generar ideas innovadoras', 'Creatividad', 'true', '2026-01-06 22:27:17'),
	(9, '2026-01-06 22:26:47', 'Constancia y orden en el cumplimiento de actividades', 'Disciplina', 'true', '2026-01-06 22:27:18'),
	(10, '2026-01-06 22:26:48', 'Capacidad para ajustarse a cambios y nuevas situaciones', 'Adaptabilidad', 'true', '2026-01-06 22:27:19'),
	(11, '2026-01-06 22:26:49', 'Capacidad para mantener el rendimiento en situaciones exigentes', 'Trabajo bajo presión', 'true', '2026-01-06 22:27:20'),
	(12, '2026-01-06 22:26:50', 'Atención y comprensión de las opiniones de los demás', 'Escucha activa', 'true', '2026-01-06 22:27:21'),
	(13, '2026-01-06 22:26:50', 'Capacidad para manejar emociones y reacciones', 'Autocontrol', 'true', '2026-01-06 22:27:23'),
	(14, '2026-01-06 22:26:52', 'Organización eficiente del tiempo y actividades', 'Gestión del tiempo', 'true', '2026-01-06 22:27:26'),
	(15, '2026-01-06 22:26:53', 'Disposición para apoyar y cooperar con otros', 'Colaboración', 'true', '2026-01-06 22:27:24'),
	(16, '2026-01-06 22:27:06', 'Interés y entusiasmo por participar en actividades del club', 'Motivación', 'true', NULL),
	(17, '2026-01-06 22:27:05', 'Identificación y lealtad con los objetivos del club', 'Compromiso', 'true', NULL),
	(18, '2026-01-06 22:27:04', 'Trato considerado hacia los demás miembros', 'Respeto', 'true', NULL),
	(19, '2026-01-06 22:27:04', 'Capacidad para actuar sin necesidad de instrucciones constantes', 'Iniciativa', 'true', NULL),
	(20, '2026-01-06 22:27:03', 'Aceptación de ideas, culturas y opiniones diferentes', 'Tolerancia', 'true', NULL),
	(21, '2026-01-06 22:27:02', 'Actuar con transparencia y ética', 'Honestidad', 'true', NULL),
	(22, '2026-01-06 22:27:01', 'Seguridad en sí mismo y en los compañeros', 'Confianza', 'true', NULL),
	(23, '2026-01-06 22:27:01', 'Constancia para alcanzar objetivos a largo plazo', 'Perseverancia', 'true', NULL),
	(24, '2026-01-06 22:27:00', 'Capacidad para planificar actividades y recursos', 'Organización', 'true', NULL),
	(25, '2026-01-06 22:27:07', 'Participación activa en tareas grupales', 'Trabajo colaborativo', 'true', NULL),
	(26, '2026-01-06 22:26:59', 'Conciencia del impacto de las acciones en la comunidad', 'Responsabilidad social', 'true', NULL),
	(27, NULL, 'Expresar ideas respetando a los demás', 'Comunicación asertiva', 'true', '2026-01-06 22:27:10'),
	(28, '2026-01-06 22:26:58', 'Capacidad para elegir la mejor opción posible', 'Toma de decisiones', 'true', NULL),
	(29, '2026-01-06 22:26:57', 'Identificación y solución efectiva de dificultades', 'Resolución de problemas', 'true', '2026-01-06 22:29:40'),
	(30, '2026-01-06 22:26:56', 'Anticiparse a problemas y actuar oportunamente', 'Proactividad', 'true', '2026-01-06 22:27:25');
/*!40000 ALTER TABLE "soft_skill" ENABLE KEYS */;

-- Dumping structure for table public.student
CREATE TABLE IF NOT EXISTS "student" (
	"id" SERIAL NOT NULL,
	"academic_level" VARCHAR(255) NULL DEFAULT NULL,
	"created_at" TIMESTAMP NULL DEFAULT NULL,
	"entry_year" INTEGER NULL DEFAULT NULL,
	"is_open_to_new_experiences" BOOLEAN NULL DEFAULT NULL,
	"last_recommendation_at" TIMESTAMP NULL DEFAULT NULL,
	"long_term_goal" VARCHAR(1000) NULL DEFAULT NULL,
	"max_parallel_clubs" INTEGER NULL DEFAULT NULL,
	"preferred_club_type" VARCHAR(100) NULL DEFAULT NULL,
	"profile" VARCHAR(2000) NULL DEFAULT NULL,
	"recommendation_opt_in" BOOLEAN NULL DEFAULT NULL,
	"record_status" BOOLEAN NULL DEFAULT NULL,
	"semester_number" INTEGER NULL DEFAULT NULL,
	"short_term_goal" VARCHAR(500) NULL DEFAULT NULL,
	"updated_at" TIMESTAMP NULL DEFAULT NULL,
	"weekly_availability_hours" INTEGER NULL DEFAULT NULL,
	"career_id" BIGINT NULL DEFAULT NULL,
	"user_info_id" BIGINT NOT NULL,
	PRIMARY KEY ("id"),
	UNIQUE ("user_info_id"),
	CONSTRAINT "fk4tve5a7chbn4bj09ts38iixgj" FOREIGN KEY ("career_id") REFERENCES "career" ("id") ON UPDATE NO ACTION ON DELETE NO ACTION,
	CONSTRAINT "fknt6img8jpwcw46sv60g0oy0ln" FOREIGN KEY ("user_info_id") REFERENCES "user_info" ("id") ON UPDATE NO ACTION ON DELETE NO ACTION
);

-- Dumping data for table public.student: -1 rows
/*!40000 ALTER TABLE "student" DISABLE KEYS */;
INSERT INTO "student" ("id", "academic_level", "created_at", "entry_year", "is_open_to_new_experiences", "last_recommendation_at", "long_term_goal", "max_parallel_clubs", "preferred_club_type", "profile", "recommendation_opt_in", "record_status", "semester_number", "short_term_goal", "updated_at", "weekly_availability_hours", "career_id", "user_info_id") VALUES
	(1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'true', NULL, NULL, NULL, NULL, NULL, 1),
	(2, NULL, NULL, NULL, 'true', NULL, NULL, 2, NULL, NULL, 'true', 'true', 3, NULL, NULL, 6, NULL, 4);
/*!40000 ALTER TABLE "student" ENABLE KEYS */;

-- Dumping structure for table public.student_interests
CREATE TABLE IF NOT EXISTS "student_interests" (
	"student_id" BIGINT NOT NULL,
	"interest_id" BIGINT NOT NULL,
	PRIMARY KEY ("student_id", "interest_id"),
	CONSTRAINT "fk322i5o0n5kvrq0npojentp8ut" FOREIGN KEY ("student_id") REFERENCES "student" ("id") ON UPDATE NO ACTION ON DELETE NO ACTION,
	CONSTRAINT "fk91fltle44f3dgfhq3qdexnfj0" FOREIGN KEY ("interest_id") REFERENCES "interest" ("id") ON UPDATE NO ACTION ON DELETE NO ACTION
);

-- Dumping data for table public.student_interests: -1 rows
/*!40000 ALTER TABLE "student_interests" DISABLE KEYS */;
INSERT INTO "student_interests" ("student_id", "interest_id") VALUES
	(2, 1),
	(2, 2),
	(2, 5);
/*!40000 ALTER TABLE "student_interests" ENABLE KEYS */;

-- Dumping structure for table public.student_mi_answer
CREATE TABLE IF NOT EXISTS "student_mi_answer" (
	"id" SERIAL NOT NULL,
	"created_at" TIMESTAMP NULL DEFAULT NULL,
	"record_status" BOOLEAN NULL DEFAULT NULL,
	"score" INTEGER NULL DEFAULT NULL,
	"updated_at" TIMESTAMP NULL DEFAULT NULL,
	"mi_question_id" BIGINT NULL DEFAULT NULL,
	"student_id" BIGINT NULL DEFAULT NULL,
	PRIMARY KEY ("id"),
	CONSTRAINT "fkftxicytsp32hommr8qej4iw52" FOREIGN KEY ("mi_question_id") REFERENCES "mi_question" ("id") ON UPDATE NO ACTION ON DELETE NO ACTION,
	CONSTRAINT "fkkds3twkdna922xeap6pty6k4x" FOREIGN KEY ("student_id") REFERENCES "student" ("id") ON UPDATE NO ACTION ON DELETE NO ACTION
);

-- Dumping data for table public.student_mi_answer: -1 rows
/*!40000 ALTER TABLE "student_mi_answer" DISABLE KEYS */;
INSERT INTO "student_mi_answer" ("id", "created_at", "record_status", "score", "updated_at", "mi_question_id", "student_id") VALUES
	(1, '2026-01-12 12:10:28.269576', 'true', 3, NULL, 1, 2),
	(2, '2026-01-12 12:10:28.269576', 'true', 3, NULL, 2, 2),
	(3, '2026-01-12 12:10:28.269576', 'true', 2, NULL, 3, 2),
	(4, '2026-01-12 12:10:28.269576', 'true', 2, NULL, 4, 2),
	(5, '2026-01-12 12:10:28.269576', 'true', 3, NULL, 5, 2),
	(6, '2026-01-12 12:10:28.269576', 'true', 3, NULL, 6, 2),
	(7, '2026-01-12 12:10:28.269576', 'true', 5, NULL, 7, 2),
	(8, '2026-01-12 12:10:28.269576', 'true', 5, NULL, 8, 2),
	(9, '2026-01-12 12:10:28.269576', 'true', 2, NULL, 9, 2),
	(10, '2026-01-12 12:10:28.269576', 'true', 2, NULL, 10, 2),
	(11, '2026-01-12 12:10:28.269576', 'true', 3, NULL, 11, 2),
	(12, '2026-01-12 12:10:28.269576', 'true', 3, NULL, 12, 2),
	(13, '2026-01-12 12:10:28.269576', 'true', 4, NULL, 13, 2),
	(14, '2026-01-12 12:10:28.269576', 'true', 4, NULL, 14, 2),
	(15, '2026-01-12 12:10:28.269576', 'true', 2, NULL, 15, 2),
	(16, '2026-01-12 12:10:28.269576', 'true', 2, NULL, 16, 2);
/*!40000 ALTER TABLE "student_mi_answer" ENABLE KEYS */;

-- Dumping structure for table public.student_preference
CREATE TABLE IF NOT EXISTS "student_preference" (
	"id" SERIAL NOT NULL,
	"avoid_club_types" VARCHAR(500) NULL DEFAULT NULL,
	"created_at" TIMESTAMP NULL DEFAULT NULL,
	"preferred_club_type" VARCHAR(100) NULL DEFAULT NULL,
	"preferred_meeting_format" VARCHAR(50) NULL DEFAULT NULL,
	"priority_weight" INTEGER NULL DEFAULT NULL,
	"record_status" BOOLEAN NULL DEFAULT NULL,
	"updated_at" TIMESTAMP NULL DEFAULT NULL,
	"student_id" BIGINT NOT NULL,
	PRIMARY KEY ("id"),
	CONSTRAINT "fkau9fpj47re728yumhlqqs6l8n" FOREIGN KEY ("student_id") REFERENCES "student" ("id") ON UPDATE NO ACTION ON DELETE NO ACTION,
	CONSTRAINT "student_preference_preferred_meeting_format_check" CHECK (((preferred_meeting_format)::text = ANY ((ARRAY['PRESENCIAL'::character varying, 'VIRTUAL'::character varying, 'HIBRIDO'::character varying])::text[])))
);

-- Dumping data for table public.student_preference: -1 rows
/*!40000 ALTER TABLE "student_preference" DISABLE KEYS */;
INSERT INTO "student_preference" ("id", "avoid_club_types", "created_at", "preferred_club_type", "preferred_meeting_format", "priority_weight", "record_status", "updated_at", "student_id") VALUES
	(1, '', '2026-01-12 13:08:54.256423', 'null', 'HIBRIDO', 10, 'true', NULL, 2);
/*!40000 ALTER TABLE "student_preference" ENABLE KEYS */;

-- Dumping structure for table public.student_preferred_reasons
CREATE TABLE IF NOT EXISTS "student_preferred_reasons" (
	"student_id" BIGINT NOT NULL,
	"club_reason_id" BIGINT NOT NULL,
	PRIMARY KEY ("student_id", "club_reason_id"),
	CONSTRAINT "fk46gi4gen5wbk3g8u6dy9tdhkw" FOREIGN KEY ("student_id") REFERENCES "student" ("id") ON UPDATE NO ACTION ON DELETE NO ACTION,
	CONSTRAINT "fkiio8hru8ygqj1wsih2t1ayad1" FOREIGN KEY ("club_reason_id") REFERENCES "club_reason" ("id") ON UPDATE NO ACTION ON DELETE NO ACTION
);

-- Dumping data for table public.student_preferred_reasons: -1 rows
/*!40000 ALTER TABLE "student_preferred_reasons" DISABLE KEYS */;
INSERT INTO "student_preferred_reasons" ("student_id", "club_reason_id") VALUES
	(2, 1);
/*!40000 ALTER TABLE "student_preferred_reasons" ENABLE KEYS */;

-- Dumping structure for table public.student_soft_skills
CREATE TABLE IF NOT EXISTS "student_soft_skills" (
	"student_id" BIGINT NOT NULL,
	"soft_skill_id" BIGINT NOT NULL,
	PRIMARY KEY ("student_id", "soft_skill_id"),
	CONSTRAINT "fkdou1ld4pa95ct9ppcnsmf1k3o" FOREIGN KEY ("student_id") REFERENCES "student" ("id") ON UPDATE NO ACTION ON DELETE NO ACTION,
	CONSTRAINT "fkgf2skwaw87uwo3x7gl2m6s3vu" FOREIGN KEY ("soft_skill_id") REFERENCES "soft_skill" ("id") ON UPDATE NO ACTION ON DELETE NO ACTION
);

-- Dumping data for table public.student_soft_skills: -1 rows
/*!40000 ALTER TABLE "student_soft_skills" DISABLE KEYS */;
INSERT INTO "student_soft_skills" ("student_id", "soft_skill_id") VALUES
	(2, 1),
	(2, 2),
	(2, 4),
	(2, 5);
/*!40000 ALTER TABLE "student_soft_skills" ENABLE KEYS */;

-- Dumping structure for table public.student_survey
CREATE TABLE IF NOT EXISTS "student_survey" (
	"id" SERIAL NOT NULL,
	"completed_at" TIMESTAMP NULL DEFAULT NULL,
	"created_at" TIMESTAMP NULL DEFAULT NULL,
	"llm_response" TEXT NULL DEFAULT NULL,
	"raw_answers_json" TEXT NULL DEFAULT NULL,
	"survey_version" VARCHAR(20) NULL DEFAULT NULL,
	"updated_at" TIMESTAMP NULL DEFAULT NULL,
	"student_id" BIGINT NOT NULL,
	PRIMARY KEY ("id"),
	UNIQUE ("student_id"),
	CONSTRAINT "fkbvkc8p2qo5maibnm93d9pkx47" FOREIGN KEY ("student_id") REFERENCES "student" ("id") ON UPDATE NO ACTION ON DELETE NO ACTION
);

-- Dumping structure for table public.student_survey_club_reasons
CREATE TABLE IF NOT EXISTS "student_survey_club_reasons" (
	"student_survey_id" BIGINT NOT NULL,
	"club_reason_id" BIGINT NOT NULL,
	PRIMARY KEY ("student_survey_id", "club_reason_id"),
	CONSTRAINT "fkn19ra0oevkelwsfxucg5w5or4" FOREIGN KEY ("club_reason_id") REFERENCES "club_reason" ("id") ON UPDATE NO ACTION ON DELETE NO ACTION,
	CONSTRAINT "fkt0b2ie684lve579wkinvikwpc" FOREIGN KEY ("student_survey_id") REFERENCES "student_survey" ("id") ON UPDATE NO ACTION ON DELETE NO ACTION
);

-- Dumping data for table public.student_survey_club_reasons: -1 rows
/*!40000 ALTER TABLE "student_survey_club_reasons" DISABLE KEYS */;
INSERT INTO "student_survey_club_reasons" ("student_survey_id", "club_reason_id") VALUES
	(1, 1);
/*!40000 ALTER TABLE "student_survey_club_reasons" ENABLE KEYS */;

-- Dumping structure for table public.student_survey_interests
CREATE TABLE IF NOT EXISTS "student_survey_interests" (
	"student_survey_id" BIGINT NOT NULL,
	"interest_id" BIGINT NOT NULL,
	PRIMARY KEY ("student_survey_id", "interest_id"),
	CONSTRAINT "fk26k6rdrr1ntqxe027w1md2li0" FOREIGN KEY ("interest_id") REFERENCES "interest" ("id") ON UPDATE NO ACTION ON DELETE NO ACTION,
	CONSTRAINT "fk45sbjih5kyltstuv8skdjsdoq" FOREIGN KEY ("student_survey_id") REFERENCES "student_survey" ("id") ON UPDATE NO ACTION ON DELETE NO ACTION
);

-- Dumping data for table public.student_survey_interests: -1 rows
/*!40000 ALTER TABLE "student_survey_interests" DISABLE KEYS */;
INSERT INTO "student_survey_interests" ("student_survey_id", "interest_id") VALUES
	(1, 1),
	(1, 2),
	(1, 5);
/*!40000 ALTER TABLE "student_survey_interests" ENABLE KEYS */;

-- Dumping structure for table public.student_survey_soft_skills
CREATE TABLE IF NOT EXISTS "student_survey_soft_skills" (
	"student_survey_id" BIGINT NOT NULL,
	"soft_skill_id" BIGINT NOT NULL,
	PRIMARY KEY ("student_survey_id", "soft_skill_id"),
	CONSTRAINT "fkeh4i54rh24kio9rp5qnu2hv0a" FOREIGN KEY ("student_survey_id") REFERENCES "student_survey" ("id") ON UPDATE NO ACTION ON DELETE NO ACTION,
	CONSTRAINT "fkgbjlhje34j6u9f0xylnmnaour" FOREIGN KEY ("soft_skill_id") REFERENCES "soft_skill" ("id") ON UPDATE NO ACTION ON DELETE NO ACTION
);

-- Dumping data for table public.student_survey_soft_skills: -1 rows
/*!40000 ALTER TABLE "student_survey_soft_skills" DISABLE KEYS */;
INSERT INTO "student_survey_soft_skills" ("student_survey_id", "soft_skill_id") VALUES
	(1, 1),
	(1, 2),
	(1, 4),
	(1, 5);
/*!40000 ALTER TABLE "student_survey_soft_skills" ENABLE KEYS */;

-- Dumping structure for table public.system_parameters
CREATE TABLE IF NOT EXISTS "system_parameters" (
	"id" SERIAL NOT NULL,
	"created_at" TIMESTAMP NULL DEFAULT NULL,
	"description" VARCHAR(255) NULL DEFAULT NULL,
	"mnemonic" VARCHAR(255) NULL DEFAULT NULL,
	"name" VARCHAR(255) NULL DEFAULT NULL,
	"record_status" BOOLEAN NULL DEFAULT NULL,
	"updated_at" TIMESTAMP NULL DEFAULT NULL,
	"value" VARCHAR(255) NULL DEFAULT NULL,
	PRIMARY KEY ("id")
);

-- Dumping data for table public.system_parameters: -1 rows
/*!40000 ALTER TABLE "system_parameters" DISABLE KEYS */;
INSERT INTO "system_parameters" ("id", "created_at", "description", "mnemonic", "name", "record_status", "updated_at", "value") VALUES
	(1, '2026-01-06 22:49:51', 'Rate limiting', 'WHITE_LISTED_IP', 'WHITE_LISTED_IP', 'true', '2026-01-06 22:50:10', '["192.1.1.1"]');
/*!40000 ALTER TABLE "system_parameters" ENABLE KEYS */;

-- Dumping structure for table public.user_info
CREATE TABLE IF NOT EXISTS "user_info" (
	"id" SERIAL NOT NULL,
	"accept_privacy" BOOLEAN NULL DEFAULT NULL,
	"accept_terms" BOOLEAN NULL DEFAULT NULL,
	"birth_date" DATE NULL DEFAULT NULL,
	"created_at" TIMESTAMP NULL DEFAULT NULL,
	"email" VARCHAR(255) NULL DEFAULT NULL,
	"first_login" BOOLEAN NULL DEFAULT NULL,
	"first_name" VARCHAR(255) NULL DEFAULT NULL,
	"national_id" VARCHAR(10) NULL DEFAULT NULL,
	"password" VARCHAR(100) NULL DEFAULT NULL,
	"phone" VARCHAR(50) NULL DEFAULT NULL,
	"record_status" BOOLEAN NULL DEFAULT NULL,
	"last_name" VARCHAR(255) NULL DEFAULT NULL,
	"updated_at" TIMESTAMP NULL DEFAULT NULL,
	"username" VARCHAR(255) NOT NULL,
	PRIMARY KEY ("id")
);

-- Dumping data for table public.user_info: -1 rows
/*!40000 ALTER TABLE "user_info" DISABLE KEYS */;
INSERT INTO "user_info" ("id", "accept_privacy", "accept_terms", "birth_date", "created_at", "email", "first_login", "first_name", "national_id", "password", "phone", "record_status", "last_name", "updated_at", "username") VALUES
	(1, 'true', 'true', '2006-01-06', '2026-01-06 20:54:25', 'sienriquez1@espe.edu.ec', 'true', 'Selena', '2300929292', '$2a$12$mUn7bAIXJg3dnfTySkcpyOQu3yH6AOXasRpCTk3Qw77fSTy72LW4u', '0939470232', 'true', 'Enriquez', '2026-01-06 20:55:13', 'selenaisabel'),
	(2, 'true', 'true', '2006-01-06', '2026-01-06 20:54:25', 'superadmin@espe.edu.ec', 'true', 'Admin', '2300929291', '$2a$12$bjx1YVWIjZV0QbUosb9LlOKDJi6TijpEcq/l61gkBlhSKSBNoG1b2', '0939470232', 'true', 'Super Admin', '2026-01-06 20:55:13', 'superadmin'),
	(3, 'true', 'true', '2006-01-06', '2026-01-06 20:54:25', 'administrador@espe.edu.ec', 'true', 'Administrador', '2300929211', '$2a$12$aivGtmnAS3iu2.EVwhdXqelgPuQzW9KenuVcAqZrm334VoNbMtYl6', '0939470232', 'true', 'ESPE', '2026-01-06 20:55:13', 'administrador'),
	(4, 'true', 'true', '2006-01-06', '2026-01-06 20:54:25', 'estudiante@espe.edu.ec', 'true', 'Estudiante', '2300929211', '$2a$12$83USLYGT2AYpHZMQg6D9ruA/XWE/oC0DhREfjjEzXJHV1Z2Y2/ig2', '0939470232', 'true', 'ESPE', '2026-01-06 20:55:13', 'estudiante'),
	(5, 'true', 'true', '2006-01-06', '2026-01-06 20:54:25', 'profesor@espe.edu.ec', 'true', 'Profesor', '2300929222', '$2a$12$vjTgUVQ5.lw8bVmLoOGjBexvEWzecPxpwTIMrAvUMnp0ytyr15zYC', '0939470232', 'true', 'ESPE', '2026-01-06 20:55:13', 'profesor'),
	(6, 'true', 'true', '2006-01-06', '2026-01-06 20:54:25', 'psicologo@espe.edu.ec', 'true', 'Profesor', '1100929222', '$2a$12$xoS6.PBda/pifhcjxkUjpuImcpkHV9aOr8E1EMpD5grrQqApcHt6G', '0939470232', 'true', 'ESPE', '2026-01-06 20:55:13', 'psicologo'),
	(7, 'true', 'true', '2000-05-15', '2026-01-10 03:01:01.530261', 'juan@espe.edu.ec', 'false', 'Juan', '2300287261', '$2a$10$.wJgr/tz4cN7Pr.cdajV/OwtNK6BnERSXO6XbGXEpM2oilpO1deGG', '0991234567', 'false', 'Pérez García', '2026-01-10 03:01:01.530285', 'juanpro1'),
	(8, 'true', 'true', '2000-05-15', '2026-01-10 03:01:48.740191', 'appatino@espe.edu.ec', 'false', 'Juan', '2300287246', '$2a$10$XHxR/Fr5QiqsRZR/kDE4w.3RhnzwLuz1HfV4og8xnCvy2/2sbvxhm', '0991234567', 'false', 'Pérez García', '2026-01-10 03:01:48.74021', 'anyel-ec'),
	(9, 'true', 'true', '2000-05-15', '2026-01-10 03:04:25.832792', 'rsvillavicencio1@espe.edu.ec', 'false', 'Juan', '1723237119', '$2a$10$4kiWWVKQdeIdU8F3XWm/K.b8UJLUVywKRboV9h7ZHZViUiT2BFyfu', '0991234567', 'true', 'Pérez García', '2026-01-10 03:11:06.630822', 'Ronyy-Villa'),
	(12, 'true', 'true', NULL, '2026-01-10 19:17:16.239057', 'admin1235@espe.edu.ec', NULL, 'Juan', NULL, '$2a$10$JkqMlei1QFFn/2RN/FZAXOQbRicHQgmfI3Ya1YFUqWl4D8Sl1AQsK', '+593987654321', 'true', 'Pérez', '2026-01-10 19:17:16.239057', 'admin0511123'),
	(13, 'true', 'true', '1990-05-15', '2026-01-10 19:26:42.04102', 'admin12325@espe.edu.ec', 'false', 'Juandado', NULL, '$2a$10$a652sVfOdTzcCygJACMGe.bZKSf7lMa0MMxIFQD47LyG1ce2aEAou', '+593987654321', 'true', 'Pérez', '2026-01-10 19:26:42.04102', 'admin05111223');
/*!40000 ALTER TABLE "user_info" ENABLE KEYS */;

-- Dumping structure for table public.user_info_roles
CREATE TABLE IF NOT EXISTS "user_info_roles" (
	"user_info_id" BIGINT NOT NULL,
	"user_role_id" BIGINT NOT NULL,
	CONSTRAINT "fke65si118lwa824w1hnu68whal" FOREIGN KEY ("user_info_id") REFERENCES "user_info" ("id") ON UPDATE NO ACTION ON DELETE NO ACTION,
	CONSTRAINT "fkfjyh5vffmi9o30dymqq2bhmvs" FOREIGN KEY ("user_role_id") REFERENCES "user_role" ("id") ON UPDATE NO ACTION ON DELETE NO ACTION
);

-- Dumping data for table public.user_info_roles: -1 rows
/*!40000 ALTER TABLE "user_info_roles" DISABLE KEYS */;
INSERT INTO "user_info_roles" ("user_info_id", "user_role_id") VALUES
	(1, 1),
	(2, 1),
	(3, 2),
	(4, 6),
	(5, 4),
	(6, 3),
	(7, 6),
	(8, 6),
	(9, 6),
	(12, 1),
	(13, 1);
/*!40000 ALTER TABLE "user_info_roles" ENABLE KEYS */;

-- Dumping structure for table public.user_pin
CREATE TABLE IF NOT EXISTS "user_pin" (
	"id" SERIAL NOT NULL,
	"created_at" TIMESTAMP NOT NULL,
	"expires_at" TIMESTAMP NULL DEFAULT NULL,
	"pin" VARCHAR(10) NOT NULL,
	"purpose" VARCHAR(30) NULL DEFAULT NULL,
	"used" BOOLEAN NOT NULL,
	"used_at" TIMESTAMP NULL DEFAULT NULL,
	"user_id" BIGINT NOT NULL,
	PRIMARY KEY ("id"),
	CONSTRAINT "fk6qmld7xx9pnl78d13gk9tepw5" FOREIGN KEY ("user_id") REFERENCES "user_info" ("id") ON UPDATE NO ACTION ON DELETE NO ACTION
);

-- Dumping data for table public.user_pin: -1 rows
/*!40000 ALTER TABLE "user_pin" DISABLE KEYS */;
INSERT INTO "user_pin" ("id", "created_at", "expires_at", "pin", "purpose", "used", "used_at", "user_id") VALUES
	(1, '2026-01-10 03:01:01.728912', '2026-01-10 03:16:01.728912', '672475', 'PRE_REGISTER', 'false', NULL, 7),
	(2, '2026-01-10 03:01:48.877993', '2026-01-10 03:16:48.877993', '485236', 'PRE_REGISTER', 'false', NULL, 8),
	(3, '2026-01-10 03:04:25.972651', '2026-01-10 03:19:25.972651', '587289', 'PRE_REGISTER', 'true', '2026-01-10 03:11:06.566618', 9);
/*!40000 ALTER TABLE "user_pin" ENABLE KEYS */;

-- Dumping structure for table public.user_role
CREATE TABLE IF NOT EXISTS "user_role" (
	"id" SERIAL NOT NULL,
	"created_at" TIMESTAMP NULL DEFAULT NULL,
	"description" VARCHAR(255) NULL DEFAULT NULL,
	"hierarchy" INTEGER NULL DEFAULT NULL,
	"is_active" BOOLEAN NULL DEFAULT NULL,
	"name" VARCHAR(255) NOT NULL,
	"record_status" BOOLEAN NULL DEFAULT NULL,
	"updated_at" TIMESTAMP NULL DEFAULT NULL,
	PRIMARY KEY ("id")
);

-- Dumping data for table public.user_role: -1 rows
/*!40000 ALTER TABLE "user_role" DISABLE KEYS */;
INSERT INTO "user_role" ("id", "created_at", "description", "hierarchy", "is_active", "name", "record_status", "updated_at") VALUES
	(1, '2026-01-06 20:47:08', 'Superadmin', 1, 'true', 'ROLE_SUPERADMIN', 'true', '2026-01-06 20:47:23'),
	(2, '2026-01-06 20:47:08', 'Admin', 2, 'true', 'ROLE_ADMIN', 'true', '2026-01-06 20:47:23'),
	(3, '2026-01-06 20:49:02', 'Psicologa', 3, 'true', 'ROLE_PSYCHOLOGIST', 'true', '2026-01-06 20:50:17'),
	(4, '2026-01-06 20:49:02', 'Teacher', 4, 'true', 'ROLE_TEACHER', 'true', '2026-01-06 20:50:17'),
	(5, '2026-01-06 20:49:02', 'Presidente', 5, 'true', 'ROLE_PRESIDENT', 'true', '2026-01-06 20:50:17'),
	(6, '2026-01-06 20:49:02', 'Student', 6, 'true', 'ROLE_STUDENT', 'true', '2026-01-06 20:50:17');
/*!40000 ALTER TABLE "user_role" ENABLE KEYS */;
