

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

## Ejemplos de Comandos de Consola utiles y necesarios.
- [Listar Bases de Datos](#listar-bases-de-datos)
- [Conectar a una Base de Datos](#conectar-a-una-base-de-datos)
- [Listar Tablas](#listar-tablas)
- [Describir una Tabla](#describir-una-tabla)
- [Listar Esquemas](#listar-esquemas)
- [Listar Usuarios](#listar-usuarios)
- [Salir de psql](#salir-de-psql)
- [Ejecutar un Comando SQL desde un Archivo](#ejecutar-un-comando-sql-desde-un-archivo)
- [Mostrar Comandos SQL Recientemente Ejecutados](#mostrar-comandos-sql-recientemente-ejecutados)
- [Borrar el Historial de Comandos](#borrar-el-historial-de-comandos)
- [Establecer un Formato de Salida](#establecer-un-formato-de-salida)
- [Mostrar Información de Conexión](#mostrar-información-de-conexión)
- [Ejecución de Consultas SQL Básicas](#ejecución-de-consultas-sql-básicas)
  - [Seleccionar Datos](#seleccionar-datos)
  - [Insertar Datos](#insertar-datos)
  - [Actualizar Datos](#actualizar-datos)
  - [Eliminar Datos](#eliminar-datos)
- [Notas Adicionales](#notas-adicionales)




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
 
#

# Comandos Principales de PostgreSQL

## Descripción
Este documento proporciona una lista de comandos esenciales de PostgreSQL, incluyendo sus descripciones y ejemplos de uso. Estos comandos son útiles para la administración y gestión de bases de datos en PostgreSQL.


## Listar Bases de Datos
- **Comando:** `\l`
- **Descripción:** Lista todas las bases de datos disponibles en el servidor de PostgreSQL.
- **Ejemplo:**
  ```sql
  \l
  ```

## Conectar a una Base de Datos
- **Comando:** `\c nombre_de_la_base_de_datos`
- **Descripción:** Conecta a una base de datos específica.
- **Ejemplo:**
  ```sql
  \c mi_base_de_datos
  ```

## Listar Tablas
- **Comando:** `\dt`
- **Descripción:** Muestra una lista de todas las tablas en la base de datos actual.
- **Ejemplo:**
  ```sql
  \dt
  ```

## Describir una Tabla
- **Comando:** `\d nombre_de_la_tabla`
- **Descripción:** Muestra la estructura de una tabla específica, incluyendo sus columnas, tipos de datos y restricciones.
- **Ejemplo:**
  ```sql
  \d mi_tabla
  ```

## Listar Esquemas
- **Comando:** `\dn`
- **Descripción:** Muestra una lista de todos los esquemas en la base de datos actual.
- **Ejemplo:**
  ```sql
  \dn
  ```

## Listar Usuarios
- **Comando:** `\du`
- **Descripción:** Lista todos los roles (usuarios y grupos) en el servidor de PostgreSQL.
- **Ejemplo:**
  ```sql
  \du
  ```

## Salir de psql
- **Comando:** `\q`
- **Descripción:** Salir del terminal psql.
- **Ejemplo:**
  ```sql
  \q
  ```

## Ejecutar un Comando SQL desde un Archivo
- **Comando:** `\i ruta_del_archivo`
- **Descripción:** Ejecuta comandos SQL contenidos en un archivo.
- **Ejemplo:**
  ```sql
  \i /ruta/al/archivo.sql
  ```

## Mostrar Comandos SQL Recientemente Ejecutados
- **Comando:** `\s`
- **Descripción:** Muestra el historial de comandos SQL ejecutados en la sesión actual.
- **Ejemplo:**
  ```sql
  \s
  ```

## Borrar el Historial de Comandos
- **Comando:** `\clear`
- **Descripción:** Limpia el historial de comandos en la sesión actual.
- **Ejemplo:**
  ```sql
  \clear
  ```

## Establecer un Formato de Salida
- **Comando:** `\pset formato`
- **Descripción:** Cambia el formato de la salida (ej., alineado, HTML, LaTeX).
- **Ejemplo:**
  ```sql
  \pset format aligned
  ```

## Mostrar Información de Conexión
- **Comando:** `\conninfo`
- **Descripción:** Muestra información sobre la conexión actual a la base de datos.
- **Ejemplo:**
  ```sql
  \conninfo
  ```

## Ejecución de Consultas SQL Básicas

### Seleccionar Datos
- **Comando:**
  ```sql
  SELECT * FROM nombre_de_la_tabla;
  ```
- **Descripción:** Selecciona todos los datos de una tabla específica.

### Insertar Datos
- **Comando:**
  ```sql
  INSERT INTO nombre_de_la_tabla (columna1, columna2) VALUES (valor1, valor2);
  ```
- **Descripción:** Inserta un nuevo registro en una tabla.

### Actualizar Datos
- **Comando:**
  ```sql
  UPDATE nombre_de_la_tabla SET columna1 = valor1 WHERE condicion;
  ```
- **Descripción:** Actualiza registros existentes en una tabla que cumplen con una condición.

### Eliminar Datos
- **Comando:**
  ```sql
  DELETE FROM nombre_de_la_tabla WHERE condicion;
  ```
- **Descripción:** Elimina registros de una tabla que cumplen con una condición.

## Notas Adicionales
Estos comandos son esenciales para la administración de bases de datos en PostgreSQL y son utilizados frecuentemente en la gestión diaria de bases de datos.


