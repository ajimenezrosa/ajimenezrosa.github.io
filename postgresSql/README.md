

## Alejandro Jimenez Rosa

<table>
<thead>
<tr>
  <th>Manuales de  </th>
  <th> Bases de daotos PostgresSQL -- AJ</th>
</tr>
</thead>
<tbody><tr>

<tr>
  <td><img src="https://avatars2.githubusercontent.com/u/7384546?s=460&v=4?format=jpg&name=large" alt="JuveR" width="400px" ></td>
  <td><img src="https://billeteranews.com/wp-content/uploads/2021/12/banco-popular-dominicano-office.jpg?format=jpg&name=large" alt="JuveR" width="400px" height="400px"></td>
</tr>
<!-- <tr>
  <td>Siempre</td>
  <td><img src="https://avatars2.githubusercontent.com/u/7384546?s=460&v=4?format=jpg&name=large" alt="JuveR" width="400px"></td>
</tr> -->


</tbody>
</table>

#

# Informacion :
<img src="https://warlord0blog.wordpress.com/wp-content/uploads/2018/02/best-postgresql-hosting.png?w=712" alt="JuveR" width="800px">

# 




# Guía de Administración de Bases de Datos PostgreSQL

## Índice
1. [Instalación y Configuración Inicial](#instalación-y-configuración-inicial)
2. [Gestión de Usuarios y Roles](#gestión-de-usuarios-y-roles)
3. [Seguridad](#seguridad)
4. [Copia de Seguridad y Recuperación](#copia-de-seguridad-y-recuperación)
5. [Monitoreo y Rendimiento](#monitoreo-y-rendimiento)
6. [Gestión de Índices](#gestión-de-índices)
7. [Manejo de Memoria](#manejo-de-memoria)
8. [Detección de Fragmentación y Desfragmentación de Índices](#detección-de-fragmentación-y-desfragmentación-de-índices)
9. [Detección de Cuellos de Botella](#detección-de-cuellos-de-botella)
10. [Mantenimiento Regular](#mantenimiento-regular)
11. [Automatización de Tareas](#automatización-de-tareas)

## Instalación y Configuración Inicial
### Instalación de PostgreSQL
~~~bash
# En sistemas basados en Debian/Ubuntu
sudo apt-get update
sudo apt-get install postgresql postgresql-contrib
~~~

### Configuración Inicial
~~~sql
# Modificar parámetros en el archivo de configuración postgresql.conf
# Ejemplo: 
# max_connections = 100
# shared_buffers = 128MB
~~~

## Gestión de Usuarios y Roles
### Creación de Usuarios
~~~sql
CREATE USER nombre_usuario WITH PASSWORD 'contraseña';
~~~

### Asignación de Roles
~~~sql
CREATE ROLE nombre_rol;
GRANT nombre_rol TO nombre_usuario;
~~~

## Seguridad
### Configuración de Autenticación
~~~sql
# Modificar el archivo pg_hba.conf
# Ejemplo:
# local   all             all                                     md5
~~~

### Auditoría de Accesos
~~~sql
# Configuración de log de auditoría en postgresql.conf
# Ejemplo:
# logging_collector = on
# log_directory = 'pg_log'
# log_filename = 'postgresql-%Y-%m-%d_%H%M%S.log'
~~~

## Copia de Seguridad y Recuperación
### Backup
~~~bash
pg_dump nombre_base_datos > backup.sql
~~~

### Restauración
~~~bash
psql nombre_base_datos < backup.sql
~~~

## Monitoreo y Rendimiento
### Monitoreo de Rendimiento
~~~sql
SELECT * FROM pg_stat_activity;
~~~

### Identificación de Consultas Lentas
~~~sql
SELECT pid, now() - pg_stat_activity.query_start AS duration, query, state 
FROM pg_stat_activity 
WHERE (now() - pg_stat_activity.query_start) > interval '5 minutes';
~~~

## Gestión de Índices
### Creación de Índices
~~~sql
CREATE INDEX nombre_indice ON nombre_tabla (columna1, columna2);
~~~

### Identificación de Índices No Utilizados
~~~sql
SELECT schemaname, relname, indexrelname, idx_scan
FROM pg_stat_all_indexes
WHERE idx_scan = 0;
~~~

### Visualización de Índices
~~~sql
SELECT indexname, indexdef FROM pg_indexes WHERE tablename = 'nombre_tabla';
~~~

## Manejo de Memoria
### Configuración de Parámetros de Memoria
~~~sql
# Modificar parámetros en postgresql.conf
# Ejemplo:
# shared_buffers = 256MB
# work_mem = 64MB
~~~

### Monitoreo del Uso de Memoria
~~~sql
SELECT name, setting FROM pg_settings WHERE name LIKE '%memory%' OR name LIKE '%buffer%';
~~~

## Detección de Fragmentación y Desfragmentación de Índices
### Detección de Fragmentación
~~~sql
SELECT relname, pg_size_pretty(pg_relation_size(relid)) AS size
FROM pg_stat_user_tables
ORDER BY pg_relation_size(relid) DESC;
~~~

### Reindexación de Índices
~~~sql
REINDEX INDEX nombre_indice;
REINDEX TABLE nombre_tabla;
~~~

## Detección de Cuellos de Botella
### Identificación de Consultas Lentas
~~~sql
SELECT query, total_time, calls, avg_time
FROM pg_stat_statements
ORDER BY total_time DESC
LIMIT 10;
~~~

### Identificación de Tablas con Bloqueos
~~~sql
SELECT pid, locktype, relation::regclass, mode, granted
FROM pg_locks
WHERE NOT granted;
~~~

## Mantenimiento Regular
### Vacuum y Análisis
~~~sql
VACUUM (VERBOSE, ANALYZE);
~~~

### Limpieza de Tablas
~~~sql
DELETE FROM nombre_tabla WHERE fecha < NOW() - INTERVAL '1 year';
~~~

## Automatización de Tareas
### Configuración de Auto-Vacuum
~~~sql
# Configuración en postgresql.conf
# Ejemplo:
# autovacuum = on
# autovacuum_max_workers = 3
# autovacuum_naptime = 1min
~~~

### Tareas Programadas con Cron
~~~bash
# Ejemplo de entrada en crontab para realizar un backup diario
0 2 * * * pg_dump nombre_base_datos > /ruta/al/backup/backup_diario.sql
~~~

---

### Referencias

- [Documentación Oficial de PostgreSQL](https://www.postgresql.org/docs/)
- [Guía de Administración de PostgreSQL](https://www.postgresql.org/docs/current/monitoring.html)

### Consulta que me lista todas las tablas de una base de datosw **Postgres**

~~~sql
SELECT table_schema, table_name
FROM information_schema.tables
WHERE table_schema NOT IN ('information_schema', 'pg_catalog')
  AND table_type = 'BASE TABLE'
ORDER BY table_schema, table_name;
~~~



Este documento cubre una amplia gama de aspectos de la administración de bases de datos PostgreSQL, proporcionando queries y configuraciones específicas para cada tarea. Puedes ajustar y expandir este contenido según tus necesidades específicas.
 
