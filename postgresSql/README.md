Claro, aquí tienes el documento reorganizado de forma más estructurada y profesional, tipo libro, eliminando duplicidades y fusionando secciones repetidas:

---

# Guía de Administración de Bases de Datos PostgreSQL

## Alejandro Jimenez Rosa

<table>
<thead>
<tr>
  <th>Manuales de</th>
  <th>Bases de Datos PostgreSQL -- AJ</th>
</tr>
</thead>
<tbody>
<tr>
  <td><img src="https://avatars2.githubusercontent.com/u/7384546?s=460&v=4?format=jpg&name=large" alt="AJ" width="400px"></td>
  <td><img src="https://billeteranews.com/wp-content/uploads/2021/12/banco-popular-dominicano-office.jpg?format=jpg&name=large" alt="Banco Popular" width="400px" height="400px"></td>
</tr>
</tbody>
</table>

---

## Índice
1. [Introducción](#introducción)
2. [Instalación y Configuración Inicial](#instalación-y-configuración-inicial)
3. [Gestión de Usuarios y Roles](#gestión-de-usuarios-y-roles)
4. [Seguridad](#seguridad)
5. [Copia de Seguridad y Recuperación](#copia-de-seguridad-y-recuperación)
6. [Monitoreo y Rendimiento](#monitoreo-y-rendimiento)
7. [Gestión de Índices](#gestión-de-índices)
8. [Manejo de Memoria](#manejo-de-memoria)
9. [Detección de Fragmentación y Desfragmentación de Índices](#detección-de-fragmentación-y-desfragmentación-de-índices)
10. [Detección de Cuellos de Botella](#detección-de-cuellos-de-botella)
11. [Mantenimiento Regular](#mantenimiento-regular)
12. [Automatización de Tareas](#automatización-de-tareas)
13. [Comandos de Consola](#comandos-de-consola)
14. [Ejemplos de Consultas en la Base de Datos](#ejemplos-de-consultas-en-la-base-de-datos)
15. [Referencias](#referencias)


## Manejo de indices,

101 [detectar indices Faltantes en una base de datos Postgres](#101)
102 [Detección de Índices Fragmentados](#102)
103 [Desfragmentación de Índices](#103)


---

## Introducción

La consola en PostgreSQL es una herramienta muy potente para crear, administrar y depurar nuestra base de datos. Podemos acceder a ella después de instalar PostgreSQL y haber seleccionado la opción de instalar la consola junto a la base de datos.

PostgreSQL está más estrechamente acoplado al entorno UNIX que algunos otros sistemas de bases de datos, utiliza las cuentas de usuario nativas para determinar quién se conecta a ella (de forma predeterminada). El programa que se ejecuta en la consola y que permite ejecutar consultas y comandos se llama `psql`. `psql` es la terminal interactiva para trabajar con PostgreSQL, es la interfaz de línea de comando o consola principal, así como PgAdmin es la interfaz gráfica de usuario principal de PostgreSQL.

Después de emitir un comando PostgreSQL, recibirás comentarios del servidor indicándote el resultado de un comando o mostrándote los resultados de una solicitud de información. Por ejemplo, si deseas saber qué versión de PostgreSQL estás usando actualmente, puedes hacer lo siguiente:

```sql
SELECT version();
```

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

## Comandos de Consola

### Comandos de Ayuda

#### \?
- **Descripción:** Muestra la lista de todos los comandos disponibles en consola, comandos que empiezan con backslash ( \ ).
- **Ejemplo:**
  ```sql
  \?
  ```

#### \h
- **Descripción:** Muestra la información de todas las consultas SQL disponibles en consola. Sirve también para buscar ayuda sobre una consulta específica.
- **Ejemplo:**
  ```sql
  \h ALTER
  ```

### Comandos de Navegación y Consulta de Información

#### \c
- **Descripción:** Saltar entre bases de datos.
- **Ejemplo:**
  ```sql
  \c nombre_de_la_base_de_datos
  ```

#### \l
- **Descripción:** Listar base de datos disponibles.
- **Ejemplo:**
  ```sql
  \l
  ```

#### \dt
- **Descripción:** Listar las tablas de la base de datos.
- **Ejemplo:**
  ```sql
  \dt
  ```

#### \d <nombre_tabla>
- **Descripción:** Describir una tabla.
- **Ejemplo:**
  ```sql
  \d nombre_tabla
  ```

#### \dn
- **Descripción:** Listar los esquemas de la base de datos actual.
- **Ejemplo:**
  ```sql
  \dn
  ```

#### \df
- **Descripción:** Listar las funciones disponibles de la base de datos actual.
- **Ejemplo:**
  ```sql
  \df
  ```

#### \dv
- **Descripción:** Listar las vistas de la base de datos actual.
- **Ejemplo:**
  ```sql
  \dv
  ```

#### \du
- **Descripción:** Listar los usuarios y sus roles de la base de datos actual.
- **Ejemplo:**
  ```sql
  \du
  ```



### Comandos de Inspección y Ejecución

#### \g
- **Descripción:** Volver a ejecutar el comando ejecutado justo antes.
- **Ejemplo:**
  ```sql
  \g
  ```

#### \s
- **Descripción:** Ver el historial de comandos ejecutados.
- **Ejemplo:**
  ```sql
  \s
  ```

#### \i
- **Descripción:** Ejecutar los comandos desde un archivo.
- **Ejemplo:**
  ```sql
  \i nombre_archivo
  ```

#### \e
- **Descripción:** Permite abrir un editor de texto plano, escribir comandos y ejecutar en lote.
- **Ejemplo:**
  ```sql
  \e
  ```

#### \ef
- **Descripción:** Permite editar funciones en PostgreSQL.
- **Ejemplo:**
  ```sql
  \ef
  ```

### Comandos para Debug y Optimización

#### \timing
- **Descripción:** Activar / Desactivar el contador de tiempo por consulta.
- **Ejemplo:**
  ```sql
  \timing
  ```

### Comandos para Cerrar la Consola

#### \q
- **Descripción:** Cerrar la consola.
- **Ejemplo:**
  ```sql
  \q
  ```

## Ejemplos de Consultas en la Base de Datos

### Crear Base de Datos

- **Descripción:** Para crear una base de datos.
- **Ejemplo:**
  ```sql
  CREATE DATABASE transporte;
  ```

### Conectar a la Base de Datos

- **Descripción:** Saltar de la base de datos predeterminada a la base de datos recién creada.
- **Ejemplo:**
  ```sql
  \c transporte
  ```

### Crear Tabla

- **Descripción:** Crear una tabla en la base de datos.
- **Ejemplo:**
  ```sql
  CREATE TABLE tren (
      id serial NOT NULL,
      modelo character varying,
      capacidad integer,
      CONSTRAINT tren_pkey PRIMARY KEY (id)
  );
  ```

### Consultar la Definición de la Tabla

- **Descripción:** Ver la definición de la tabla.
- **Ejemplo:**
  ```sql
  \d tren
  ```

### Consultar la Definición de la Secuencia

- **Descripción:** Ver la definición de la secuencia asociada a una columna.
- **Ejemplo:**
  ```sql
  \d tren_id_seq
  ```

### Insertar Datos

- **Descripción:** Insertar un registro en la tabla.
- **Ejemplo:**
  ```sql
  INSERT INTO tren(modelo, capacidad) VALUES ('Volvo 1', 100);
  ```

### Consultar Datos

- **Descripción:** Consultar los datos en la tabla.
- **Ejemplo:**
  ```sql
  SELECT * FROM tren;
  ```

### Actualizar Datos

- **Descripción:** Modificar los datos de un registro en la tabla.
- **Ejemplo:**
  ```sql
  UPDATE tren SET modelo = 'Honda 0726' WHERE id = 1;
  ```

### Verificar la Modificación

- **Descripción:** Verificar los datos actualizados.
- **Ejemplo:**
  ```sql
  SELECT * FROM tren;
  ```

### Eliminar Datos

- **Descripción:** Borrar un registro de la tabla.
- **Ejemplo:**
  ```sql
  DELETE FROM tren WHERE id = 1;
  ```

### Verificar el Borrado

- **Descripción:** Verificar que los datos han sido borrados.
- **Ejemplo:**
  ```sql
  SELECT * FROM tren;
  ```

### Medir Tiempos de Ejecución

- **Descripción:** Activar la herramienta que permite medir el tiempo que tarda una consulta.
- **Ejemplo:**
  ```sql
  \timing
  ```

### Ejemplo de Medición

- **Descripción:** Realizar una consulta y medir el tiempo de ejecución.
- **Ejemplo:**
  ```sql
  SELECT md5('texto a encriptar');
  ```

## Referencias

- [Documentación Oficial de PostgreSQL](https://www.postgresql.org/docs/)
- [Guía de Administración de PostgreSQL](https://www.postgresql.org/docs/current/monitoring.html)

---

Este documento cubre una amplia gama de aspectos de la administración de bases de datos PostgreSQL, proporcionando queries y configuraciones específicas para cada tarea. Puedes ajustar y expandir este contenido según tus necesidades específicas.

---

Espero que esta estructura sea de tu agrado y facilite la comprensión y manejo de PostgreSQL.

# 

## Manejo de indices,

### detectar indices Faltantes en una base de datos Postgres<a name="101"></a>

Para generar un script que identifique los índices faltantes y sugiera la creación de los mismos en PostgreSQL, podemos usar una consulta que analice los escaneos secuenciales y genere automáticamente una declaración `CREATE INDEX` para cada caso. 

~~~sql
WITH seq_scans AS (
    SELECT 
        schemaname,
        relname,
        seq_scan,
        idx_scan,
        (seq_scan - coalesce(idx_scan, 0)) AS too_much_seq
    FROM 
        pg_stat_user_tables
    WHERE 
        seq_scan - coalesce(idx_scan, 0) > 100 -- Ajusta este valor según tus necesidades
),
missing_indexes AS (
    SELECT
        s.schemaname,
        s.relname,
        a.attname AS column_name,
        'CREATE INDEX idx_' || s.relname || '_' || a.attname || ' ON ' || s.schemaname || '.' || s.relname || ' (' || a.attname || ');' AS create_index_script
    FROM 
        seq_scans s
    JOIN 
        pg_attribute a ON s.relname = a.attrelid::regclass::text
    JOIN 
        pg_class c ON a.attrelid = c.oid
    WHERE 
        a.attnum > 0 
        AND NOT a.attisdropped
        AND NOT EXISTS (
            SELECT 1 
            FROM pg_index i 
            JOIN pg_class ic ON ic.oid = i.indexrelid
            WHERE i.indrelid = c.oid 
              AND ic.relname = 'idx_' || s.relname || '_' || a.attname
        )
    ORDER BY 
        s.too_much_seq DESC
)
SELECT 
    schemaname,
    relname,
    column_name,
    create_index_script
FROM 
    missing_indexes;
~~~

### Descripción de la consulta

1. **seq_scans**: Esta subconsulta selecciona las tablas que tienen un número de escaneos secuenciales (`seq_scan`) significativamente mayor que los escaneos por índice (`idx_scan`).

2. **missing_indexes**: Esta subconsulta toma las tablas identificadas en `seq_scans` y sus columnas, y genera un script `CREATE INDEX` para cada combinación de tabla-columna que no tenga ya un índice existente.

3. **create_index_script**: La declaración final selecciona el nombre del esquema, el nombre de la tabla, el nombre de la columna y el script `CREATE INDEX` generado.

### Resultado

El resultado de esta consulta incluirá el nombre del esquema, el nombre de la tabla, el nombre de la columna y el script `CREATE INDEX` sugerido. Puedes revisar estos resultados y ejecutar los scripts generados para crear los índices faltantes.

### Nota

Es importante revisar cuidadosamente las sugerencias de índices antes de ejecutarlas, ya que la creación de índices puede afectar el rendimiento de la base de datos en ciertos casos, como en operaciones de escritura intensiva. Además, la lógica puede necesitar ajustes adicionales dependiendo de la estructura específica de tus tablas y consultas.

# 


### Detección de Índices Fragmentados<a name="102"></a>

Para detectar y desfragmentar índices fragmentados en PostgreSQL, puedes usar las siguientes consultas. 

Primero, puedes utilizar una consulta que identifique índices que están fragmentados. La fragmentación puede medirse observando la relación entre los tamaños de los índices y los bloques utilizados.

~~~sql
WITH index_stats AS (
    SELECT
        nspname AS schemaname,
        relname AS tablename,
        indexrelname AS indexname,
        pg_size_pretty(pg_relation_size(indexrelid)) AS index_size,
        idx_scan AS index_scans,
        idx_tup_read AS tuples_read,
        idx_tup_fetch AS tuples_fetched,
        CASE 
            WHEN pg_relation_size(indexrelid) / current_setting('block_size')::int > 100 THEN 'Fragmented' 
            ELSE 'Not Fragmented' 
        END AS fragmentation_status
    FROM 
        pg_stat_user_indexes
    JOIN 
        pg_index ON pg_stat_user_indexes.indexrelid = pg_index.indexrelid
    JOIN 
        pg_class ON pg_index.indexrelid = pg_class.oid
    JOIN 
        pg_namespace ON pg_class.relnamespace = pg_namespace.oid
)
SELECT 
    schemaname,
    tablename,
    indexname,
    index_size,
    index_scans,
    tuples_read,
    tuples_fetched,
    fragmentation_status
FROM 
    index_stats
WHERE 
    fragmentation_status = 'Fragmented'
ORDER BY 
    pg_relation_size(indexrelid) DESC;
~~~

### Desfragmentación de Índices<a name="103"></a>

Para desfragmentar los índices identificados como fragmentados, puedes utilizar la operación `REINDEX` en PostgreSQL. A continuación, se presenta una consulta para generar los comandos `REINDEX` necesarios.

~~~sql
WITH index_stats AS (
    SELECT
        nspname AS schemaname,
        relname AS tablename,
        indexrelname AS indexname,
        pg_size_pretty(pg_relation_size(indexrelid)) AS index_size,
        idx_scan AS index_scans,
        idx_tup_read AS tuples_read,
        idx_tup_fetch AS tuples_fetched,
        CASE 
            WHEN pg_relation_size(indexrelid) / current_setting('block_size')::int > 100 THEN 'Fragmented' 
            ELSE 'Not Fragmented' 
        END AS fragmentation_status
    FROM 
        pg_stat_user_indexes
    JOIN 
        pg_index ON pg_stat_user_indexes.indexrelid = pg_index.indexrelid
    JOIN 
        pg_class ON pg_index.indexrelid = pg_class.oid
    JOIN 
        pg_namespace ON pg_class.relnamespace = pg_namespace.oid
)
SELECT 
    'REINDEX INDEX ' || schemaname || '.' || indexname || ';' AS reindex_command
FROM 
    index_stats
WHERE 
    fragmentation_status = 'Fragmented';
~~~

### Recomendaciones y Comentarios

1. **Ejecución en Horas de Baja Carga**: La operación `REINDEX` puede ser intensiva en recursos, por lo que se recomienda ejecutarla durante períodos de baja actividad para minimizar el impacto en el rendimiento.

2. **Monitoreo de Desfragmentación**: Después de ejecutar los comandos `REINDEX`, es importante monitorear la base de datos para asegurarse de que el rendimiento ha mejorado y no se han introducido nuevos problemas.

3. **Revisar Frecuencia de Desfragmentación**: Dependiendo de la carga de trabajo y el patrón de uso, puede ser necesario ajustar la frecuencia con la que se realiza la desfragmentación de los índices.

4. **Considerar Otras Optimizaciones**: La desfragmentación de índices es solo una parte del mantenimiento de la base de datos. Considera también la optimización de consultas, la actualización de estadísticas y otras prácticas de mantenimiento regular.





# No Existe nada debajo de esta linea.
