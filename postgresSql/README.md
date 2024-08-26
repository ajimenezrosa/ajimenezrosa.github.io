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

101. [detectar indices Faltantes en una base de datos Postgres](#101)
102. [Detección de Índices Fragmentados](#102)
103. [Desfragmentación de Índices](#103)


## Particionar tablas 

201. [Partición de Tablas en PostgreSQL](#201)


## Gestión de Roles en PostgreSQL
301. [Gestión de Roles en PostgreSQL](#301)
302. [Comandos paqra menejo de persmiso y usuarios en postgres](#302)


## Creacion de `dblink` y manejo de `Commit  Rollbak Backup y Restore` en Postgres

1. [**Creación de `dblink` en PostgreSQL:**](#401)
   - [Documentación oficial de `dblink`](https://www.postgresql.org/docs/current/dblink.html)

2. [**Uso de `COMMIT` y `ROLLBACK` en PostgreSQL:**](#402)
   [Documentación oficial de `ROLLBACK`](https://www.postgresql.org/docs/current/sql-rollback.html)



1. **[Backup en PostgreSQL](#501)**
2. **[Restore en PostgreSQL](#502)**


### [**Creación de un Servidor de Réplica en PostgreSQL:**](#601)

1. **[Configuración del Servidor Primario (Master)](#602)**
2. **[Configuración del Servidor de Réplica (Slave)](#c603)**
3. **[Verificación de la Replicación](#604)**
4. **[Promoción del Servidor de Réplica a Primario](#605)**

--- 

## Eliminarlo de la base de datos de MI
- [Eliminarlo de la base de datos de MI](#eliminarmi)


---

### Seleccionar los Primeros 5 Registros 

1. [Descripción del Código](#descripción-del-código)
2. [1. Seleccionar los Primeros 5 Registros](#1-seleccionar-los-primeros-5-registros)
   - [a) Usando FETCH FIRST](#a-usando-fetch-first)
   - [b) Usando LIMIT](#b-usando-limit)
   - [c) Usando Subquery y Función de Ventana](#c-usando-subquery-y-función-de-ventana)

### Encontrar la Segunda Colegiatura Más Alta   
3. [2. Encontrar la Segunda Colegiatura Más Alta](#2-encontrar-la-segunda-colegiatura-más-alta)
   - [a) Contar por JOIN entre las Tablas](#a-contar-por-join-entre-las-tablas)
   - [b) Usando LIMIT con OFFSET](#b-usando-limit-con-offset)
   - [c) JOIN con Subconsulta](#c-join-con-subconsulta)
   - [d) Subquery en WHERE](#d-subquery-en-where)
4. [Conclusión](#conclusión)




###  Seleccionar Resultados que No se Encuentran en un Set

1. [Descripción del Código](#descripción-del-código)
2. [1. Seleccionar Resultados que No se Encuentran en un Set](#1-seleccionar-resultados-que-no-se-encuentran-en-un-set)
   - [a) Usando `NOT IN` con un Array](#a-usando-not-in-con-un-array)
   - [b) Usando `NOT IN` con una Subquery](#b-usando-not-in-con-una-subquery)

### Extraer Partes de una Fecha   
3. [2. Extraer Partes de una Fecha](#2-extraer-partes-de-una-fecha)
   - [a) Usando `EXTRACT`](#a-usando-extract)
   - [b) Usando `DATE_PART`](#b-usando-date_part)
4. [Conclusión](#conclusión)

---
### Operaciones y Extracción de Tiempos

1. [Descripción del Código](#descripción-del-código)
2. [1. Seleccionar Resultados que No se Encuentran en un Set](#1-seleccionar-resultados-que-no-se-encuentran-en-un-set)
   - [a) Usando `NOT IN` con un Array](#a-usando-not-in-con-un-array)
   - [b) Usando `NOT IN` con una Subquery](#b-usando-not-in-con-una-subquery)
3. [2. Extraer Partes de una Fecha](#2-extraer-partes-de-una-fecha)
   - [a) Usando `EXTRACT`](#a-usando-extract)
   - [b) Usando `DATE_PART`](#b-usando-date_part)
4. [3. Operaciones y Extracción de Tiempos](#3-operaciones-y-extracción-de-tiempos)
   - [a) Extraer Hora, Minutos y Segundos](#a-extraer-hora-minutos-y-segundos)
   - [b) Sumar o Restar Intervalos de Tiempo](#b-sumar-o-restar-intervalos-de-tiempo)
   - [c) Calcular Diferencia entre Tiempos](#c-calcular-diferencia-entre-tiempos)
5. [Conclusión](#conclusión)

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
        'CREATE INDEX idx_' || s.relname || '_' || a.attname || ' ON ' || s.schemaname || '.' || s.relname || ' (' || a.attname || ');' AS create_index_script,
        s.too_much_seq AS estimated_impact
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
    create_index_script,
    estimated_impact
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
        ns.nspname AS schemaname,
        c.relname AS tablename,
        i.relname AS indexname,
        pg_size_pretty(pg_relation_size(i.oid)) AS index_size,
        s.idx_scan AS index_scans,
        s.idx_tup_read AS tuples_read,
        s.idx_tup_fetch AS tuples_fetched,
        CASE 
            WHEN pg_relation_size(i.oid) / current_setting('block_size')::int > 100 THEN 'Fragmented' 
            ELSE 'Not Fragmented' 
        END AS fragmentation_status
    FROM 
        pg_stat_user_indexes s
    JOIN 
        pg_index ix ON s.indexrelid = ix.indexrelid
    JOIN 
        pg_class c ON ix.indrelid = c.oid
    JOIN 
        pg_class i ON ix.indexrelid = i.oid
    JOIN 
        pg_namespace ns ON c.relnamespace = ns.oid
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
    pg_relation_size(i.oid) DESC;

~~~

### Desfragmentación de Índices<a name="103"></a>

Para desfragmentar los índices identificados como fragmentados, puedes utilizar la operación `REINDEX` en PostgreSQL. A continuación, se presenta una consulta para generar los comandos `REINDEX` necesarios.

~~~sql
WITH index_stats AS (
    SELECT
        ns.nspname AS schemaname,
        c.relname AS tablename,
        i.relname AS indexname,
        pg_size_pretty(pg_relation_size(i.oid)) AS index_size,
        s.idx_scan AS index_scans,
        s.idx_tup_read AS tuples_read,
        s.idx_tup_fetch AS tuples_fetched,
        CASE 
            WHEN pg_relation_size(i.oid) / current_setting('block_size')::int > 100 THEN 'Fragmented' 
            ELSE 'Not Fragmented' 
        END AS fragmentation_status
    FROM 
        pg_stat_user_indexes s
    JOIN 
        pg_index ix ON s.indexrelid = ix.indexrelid
    JOIN 
        pg_class c ON ix.indrelid = c.oid
    JOIN 
        pg_class i ON ix.indexrelid = i.oid
    JOIN 
        pg_namespace ns ON c.relnamespace = ns.oid
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

# 


# **Partición de Tablas en PostgreSQL**<a name="201"></a>

## **Introducción**

La partición de tablas es una característica avanzada en PostgreSQL que permite dividir una tabla grande en partes más pequeñas y manejables, llamadas particiones. Cada partición contiene un subconjunto de los datos de la tabla, y el motor de base de datos gestiona estas particiones de manera eficiente. Esto puede mejorar el rendimiento de consultas, facilitar el manejo de datos históricos y optimizar el uso del almacenamiento.

## **Ventajas de la Partición de Tablas**

1. **Mejora del Rendimiento de Consultas**: Las consultas pueden ser más rápidas porque el motor de la base de datos solo necesita escanear las particiones relevantes en lugar de la tabla completa.

2. **Facilidad de Mantenimiento**: Las operaciones de mantenimiento, como la eliminación de datos antiguos, se simplifican, ya que es posible realizar estas operaciones en una partición específica en lugar de en toda la tabla.

3. **Optimización del Almacenamiento**: Las particiones pueden almacenarse en diferentes tablaspaces, permitiendo un mejor control sobre la distribución del almacenamiento.

4. **Paralelismo en la Ejecución**: PostgreSQL puede ejecutar en paralelo ciertas operaciones cuando las tablas están particionadas, lo que reduce los tiempos de ejecución.

## **Tipos de Particiones en PostgreSQL**

- **Rango**: Divide la tabla según un rango de valores, como fechas o números.
- **Lista**: Divide la tabla según valores específicos de una columna, como nombres de regiones o categorías.
- **Hash**: Divide la tabla utilizando una función de hash sobre una o más columnas.

## **Ejemplo Práctico: Partición por Rango**

### **Paso 1: Crear la Tabla Maestra**

Primero, se crea la tabla principal que servirá como el contenedor para las particiones.

```sql
CREATE TABLE ventas (
    id_venta SERIAL PRIMARY KEY,
    fecha DATE NOT NULL,
    cliente_id INT NOT NULL,
    total DECIMAL(10, 2) NOT NULL
) PARTITION BY RANGE (fecha);
```

### **Paso 2: Crear las Particiones**

Luego, se crean las particiones que almacenarán los datos según el rango de fechas.

```sql
CREATE TABLE ventas_2023 PARTITION OF ventas
    FOR VALUES FROM ('2023-01-01') TO ('2023-12-31');

CREATE TABLE ventas_2024 PARTITION OF ventas
    FOR VALUES FROM ('2024-01-01') TO ('2024-12-31');
```

### **Paso 3: Insertar Datos**

Cuando insertas datos en la tabla `ventas`, PostgreSQL asigna automáticamente los registros a la partición adecuada.

```sql
INSERT INTO ventas (fecha, cliente_id, total) VALUES ('2023-05-15', 1, 150.75);
```

### **Paso 4: Consultar Datos**

Las consultas se ejecutan de manera transparente, pero PostgreSQL solo accederá a las particiones que sean relevantes para la consulta.

```sql
SELECT * FROM ventas WHERE fecha BETWEEN '2023-01-01' AND '2023-06-30';
```

### **Paso 5: Mantenimiento de Particiones**

Eliminar datos antiguos es sencillo. Por ejemplo, para eliminar todos los datos del 2023:

```sql
DROP TABLE ventas_2023;
```

## **Consideraciones Importantes**

- **Índices**: Cada partición puede tener sus propios índices, pero es necesario asegurarse de que estén configurados correctamente para optimizar las consultas.
- **Constraints**: Las restricciones de integridad se deben definir en cada partición si es necesario.
- **Herencia de tablas**: La partición utiliza un modelo de herencia de tablas, pero a diferencia de las tablas heredadas clásicas, las particiones están optimizadas para su manejo eficiente.

## **Conclusión**

La partición de tablas en PostgreSQL es una poderosa herramienta para manejar grandes volúmenes de datos de manera eficiente. Facilita el mantenimiento, mejora el rendimiento de las consultas y optimiza el uso del almacenamiento. Sin embargo, es importante comprender cómo funcionan las particiones y planificar cuidadosamente la estructura de las tablas para aprovechar al máximo esta funcionalidad.

Este ejemplo proporciona una base sólida para entender y utilizar las particiones en PostgreSQL, y puede ser fácilmente expandido o adaptado según las necesidades específicas del proyecto.

# 

Aquí tienes la versión actualizada de la documentación con la sección adicional sobre cómo listar los roles existentes en PostgreSQL:

---

# **Gestión de Roles en PostgreSQL**<a name="301"></a>

## **Introducción**

En PostgreSQL, los roles son un concepto clave para la gestión de la seguridad y el control de acceso a la base de datos. Un rol puede representar a un usuario individual o un grupo de usuarios, y se puede configurar con diferentes permisos para acceder a bases de datos, tablas, y otros objetos. Esta documentación cubre cómo crear, modificar y asignar roles a los usuarios en PostgreSQL, así como cómo listar los roles existentes.

## **Conceptos Básicos**

- **Rol**: Una entidad a la que se le pueden otorgar permisos. Un rol puede ser un usuario o un grupo de usuarios.
- **Permisos**: Accesos o privilegios específicos asignados a un rol, como SELECT, INSERT, UPDATE, DELETE, etc.
- **Usuario**: Un rol con la capacidad de autenticarse en la base de datos.

## **Crear Roles**

### **1. Crear un Rol sin Privilegios**

Este comando crea un rol sin ningún privilegio especial. El rol puede utilizarse como un usuario o un grupo.

```sql
CREATE ROLE nombre_del_rol;
```

### **2. Crear un Rol con Privilegios de Inicio de Sesión**

Para crear un rol que pueda iniciar sesión en la base de datos (es decir, un usuario), usa el atributo `LOGIN`:

```sql
CREATE ROLE nombre_del_usuario WITH LOGIN PASSWORD 'contraseña';
```

### **3. Crear un Rol con Privilegios Específicos**

Puedes crear un rol con privilegios específicos como SUPERUSER, CREATEDB, CREATEROLE, etc.

```sql
CREATE ROLE nombre_del_usuario WITH LOGIN PASSWORD 'contraseña' SUPERUSER CREATEDB CREATEROLE;
```

## **Modificar Roles**

### **1. Cambiar la Contraseña de un Rol**

Para cambiar la contraseña de un rol existente:

```sql
ALTER ROLE nombre_del_usuario WITH PASSWORD 'nueva_contraseña';
```

### **2. Asignar o Revocar Privilegios**

Para otorgar o revocar privilegios a un rol existente:

```sql
ALTER ROLE nombre_del_rol WITH CREATEDB;  -- Otorga privilegios para crear bases de datos
ALTER ROLE nombre_del_rol WITH NOSUPERUSER;  -- Revoca privilegios de superusuario
```

### **3. Cambiar el Nombre de un Rol**

Para cambiar el nombre de un rol:

```sql
ALTER ROLE nombre_viejo RENAME TO nombre_nuevo;
```

### **4. Cambiar los Atributos de Inicio de Sesión**

Para habilitar o deshabilitar la capacidad de un rol para iniciar sesión:

```sql
ALTER ROLE nombre_del_rol WITH LOGIN;  -- Habilitar inicio de sesión
ALTER ROLE nombre_del_rol WITH NOLOGIN;  -- Deshabilitar inicio de sesión
```

## **Asignar Roles a Usuarios**

### **1. Otorgar un Rol a Otro Rol (Herencia de Roles)**

Un rol puede heredar los privilegios de otro rol. Esto es útil para agrupar permisos y asignarlos a varios usuarios.

```sql
GRANT rol_base TO rol_destinatario;
```

### **2. Revocar un Rol de Otro Rol**

Para eliminar la herencia de un rol sobre otro:

```sql
REVOKE rol_base FROM rol_destinatario;
```

### **3. Ver los Roles y sus Permisos**

Puedes consultar los roles y sus permisos usando:

```sql
\du  -- Comando en psql para listar roles
```

O mediante una consulta SQL:

```sql
SELECT rolname, rolsuper, rolinherit, rolcreaterole, rolcreatedb, rolcanlogin FROM pg_roles;
```

## **Lista de Roles Existentes en PostgreSQL**

PostgreSQL viene con algunos roles predefinidos que cumplen funciones específicas:

- **`postgres`**: Este es el rol de superusuario predeterminado creado durante la instalación de PostgreSQL. Tiene todos los privilegios posibles.
- **`pg_read_all_data`**: Un rol que tiene permiso de solo lectura en todas las tablas y vistas de todas las bases de datos.
- **`pg_write_all_data`**: Un rol que tiene permiso de escritura en todas las tablas y vistas de todas las bases de datos.
- **`pg_monitor`**: Un rol que tiene permisos para ejecutar funciones de monitoreo y consultas sobre estadísticas del sistema.
- **`pg_signal_backend`**: Permite a un rol enviar señales a otros procesos de servidor, como el comando `pg_terminate_backend`.

### **Listar Todos los Roles en PostgreSQL**

Para listar todos los roles en el sistema PostgreSQL desde la consola `psql`, puedes utilizar los siguientes métodos:

#### **Método 1: Usar el Comando Interno `\du`**

En la consola `psql`, simplemente ejecuta:

```sql
\du
```

Este comando mostrará una lista de todos los roles en el sistema, junto con información sobre sus privilegios.

#### **Método 2: Usar una Consulta SQL**

Alternativamente, puedes ejecutar una consulta SQL para obtener una lista más detallada de los roles:

```sql
SELECT rolname, rolsuper, rolinherit, rolcreaterole, rolcreatedb, rolcanlogin 
FROM pg_roles;
```

Esta consulta te proporcionará una lista de todos los roles junto con sus atributos principales, como si son superusuarios, si pueden heredar privilegios, si pueden crear roles o bases de datos, y si pueden iniciar sesión.

## **Ejemplos Prácticos**

### **Ejemplo 1: Crear un Rol de Solo Lectura**

1. Crear el rol:
    ```sql
    CREATE ROLE solo_lectura;
    ```

2. Asignar permisos de solo lectura:
    ```sql
    GRANT SELECT ON ALL TABLES IN SCHEMA public TO solo_lectura;
    ```

3. Asignar este rol a un usuario:
    ```sql
    GRANT solo_lectura TO nombre_del_usuario;
    ```

### **Ejemplo 2: Crear un Usuario con Privilegios Administrativos**

1. Crear un rol con permisos administrativos:
    ```sql
    CREATE ROLE admin WITH LOGIN PASSWORD 'admin_password' SUPERUSER CREATEDB CREATEROLE;
    ```

2. Asignar este rol a un usuario específico:
    ```sql
    GRANT admin TO nombre_del_usuario;
    ```


    ~~~cmd
    transporte=# \h create rol
    ~~~
Command:     CREATE ROLE
Description: define a new database role
Syntax:
CREATE ROLE name [ [ WITH ] option [ ... ] ]

where option can be:

      SUPERUSER | NOSUPERUSER
    | CREATEDB | NOCREATEDB
    | CREATEROLE | NOCREATEROLE
    | INHERIT | NOINHERIT
    | LOGIN | NOLOGIN
    | REPLICATION | NOREPLICATION
    | BYPASSRLS | NOBYPASSRLS
    | CONNECTION LIMIT connlimit
    | [ ENCRYPTED ] PASSWORD 'password' | PASSWORD NULL
    | VALID UNTIL 'timestamp'
    | IN ROLE role_name [, ...]
    | IN GROUP role_name [, ...]
    | ROLE role_name [, ...]
    | ADMIN role_name [, ...]
    | USER role_name [, ...]
    | SYSID uid

para listar todos los roles que tenemos en el servidor utilizamos la instruccion 
  ~~~cmd
  \dg
~~~




## **Mejores Prácticas**

- **Usar Roles para Agrupar Permisos**: En lugar de otorgar permisos directamente a los usuarios, agrupa los permisos en roles y asigna esos roles a los usuarios.
- **Revisar Regularmente los Privilegios**: Realiza auditorías periódicas de los permisos y roles para asegurarte de que se siguen las políticas de seguridad.
- **Asignar el Mínimo Privilegio Necesario**: Evita otorgar más permisos de los necesarios a cualquier rol o usuario.

## **Conclusión**

La gestión de roles en PostgreSQL es esencial para mantener una base de datos segura y organizada. Con los comandos y prácticas descritos en esta documentación, podrás crear, modificar y asignar roles a usuarios de manera efectiva en tu entorno PostgreSQL. Además, la capacidad de listar todos los roles existentes te permitirá tener una visión clara de la estructura de seguridad de tu sistema.



Esta versión actualizada proporciona una referencia completa para la gestión de roles en PostgreSQL, incluyendo cómo listar todos los roles existentes, lo que es fundamental para auditar y administrar permisos en un entorno de producción.
# 

## Comandos paqra menejo de persmiso y usuarios en postgres<a name="302"></a>

~~~sql
-- Crear un rol llamado usuario_consulta
CREATE ROLE usuario_consulta;

-- Modificar el rol para permitir el inicio de sesión
ALTER ROLE usuario_consulta WITH LOGIN;

-- Establecer la contraseña para el rol usuario_consulta
ALTER ROLE usuario_consulta WITH PASSWORD 'etc123';

-- Comando para listar roles y grupos en PostgreSQL (debe ejecutarse en psql)
\dg
~~~

### **Explicación**

1. **CREATE ROLE usuario_consulta;**
   - Este comando crea un nuevo rol llamado `usuario_consulta` en PostgreSQL. Este rol no tiene privilegios ni la capacidad de iniciar sesión hasta que se modifique.

2. **ALTER ROLE usuario_consulta WITH LOGIN;**
   - Este comando modifica el rol `usuario_consulta` para permitir que se pueda utilizar como un usuario que puede iniciar sesión en la base de datos.

3. **ALTER ROLE usuario_consulta WITH PASSWORD 'etc123';**
   - Este comando asigna una contraseña al rol `usuario_consulta`, lo que es necesario para los roles que tienen permisos de inicio de sesión.

4. **\dg**
   - Este es un comando específico de la consola `psql` que lista todos los roles y sus permisos. Muestra detalles sobre cada rol, incluidos sus atributos como si pueden iniciar sesión, si son superusuarios, etc.

Este conjunto de comandos es útil para crear y configurar rápidamente un usuario con capacidades de consulta en una base de datos PostgreSQL. El comando `\dg` permite verificar la creación y configuración del rol.

# 


### **1. Creación de `dblink` en PostgreSQL**<a name="401"></a>
El módulo `dblink` en PostgreSQL permite ejecutar consultas en una base de datos remota desde una base de datos local. Es útil para conectarse y trabajar con diferentes bases de datos.

#### **Pasos:**
1. Instala la extensión `dblink`:
   ```sql
   CREATE EXTENSION dblink;
   ```

2. Para crear un `dblink`, necesitas proporcionar la conexión a la base de datos remota. Esto se hace utilizando la función `dblink_connect()`.

   ```sql
   SELECT dblink_connect('con1', 'host=localhost dbname=remote_db user=user password=secret');
   ```

3. Una vez conectado, puedes ejecutar consultas en la base de datos remota:
   ```sql
   SELECT * FROM dblink('con1', 'SELECT id, name FROM users') AS t(id int, name text);
   ```

4. Finalmente, cierra la conexión:
   ```sql
   SELECT dblink_disconnect('con1');
   ```

#### **Enlace directo para copiar:**
```
https://www.postgresql.org/docs/current/dblink.html
```

### **2. Uso de `COMMIT` y `ROLLBACK` en PostgreSQL***<a name="402"></a>
En PostgreSQL, las transacciones permiten agrupar varias operaciones de base de datos para que se ejecuten como una unidad atómica. `COMMIT` y `ROLLBACK` son comandos utilizados para finalizar o deshacer una transacción.

#### **Ejemplo de uso:**
1. **Iniciar una transacción:**
   ```sql
   BEGIN;
   ```

2. **Ejecutar consultas:**
   ```sql
   INSERT INTO accounts (id, balance) VALUES (1, 1000);
   UPDATE accounts SET balance = balance - 200 WHERE id = 1;
   ```

3. **Confirmar la transacción (hacer permanentes los cambios):**
   ```sql
   COMMIT;
   ```

4. **Si algo sale mal, puedes deshacer los cambios ejecutados durante la transacción:**
   ```sql
   ROLLBACK;
   ```

#### **Enlace directo para copiar:**
```
https://www.postgresql.org/docs/current/sql-rollback.html
```

# 


---

### **Backup y Restore en PostgreSQL***<a name="501"></a>

### **1. Backup en PostgreSQL**
PostgreSQL proporciona varias herramientas para realizar respaldos de tus datos. La más común es `pg_dump`, que permite realizar copias de seguridad de bases de datos en formato de script SQL o en formatos comprimidos.

#### **Ejemplo de uso de `pg_dump`:**
1. **Backup de una base de datos completa en formato SQL plano:**
   ```bash
   pg_dump -U usuario -W -F p nombre_base_de_datos > respaldo.sql
   ```
   - `-U`: Especifica el usuario de la base de datos.
   - `-W`: Solicita la contraseña del usuario.
   - `-F p`: Especifica que el formato de salida es un archivo de texto plano (plain format).
   - `nombre_base_de_datos`: Es la base de datos que deseas respaldar.

2. **Backup en formato comprimido:**
   ```bash
   pg_dump -U usuario -W -F c nombre_base_de_datos > respaldo.dump
   ```
   - `-F c`: Especifica que el formato de salida es comprimido (custom format).

#### **Enlace a la documentación oficial:**
[Documentación oficial de Backup en PostgreSQL](https://www.postgresql.org/docs/current/backup.html)

---

### **2. Restore en PostgreSQL**<a name="502"></a>
Para restaurar respaldos en PostgreSQL, se utilizan las herramientas `pg_restore` para respaldos en formatos comprimidos o `psql` para respaldos en formato de script SQL.

#### **Ejemplo de uso de `pg_restore`:**
1. **Restaurar un respaldo en formato comprimido:**
   ```bash
   pg_restore -U usuario -W -d nombre_base_de_datos respaldo.dump
   ```
   - `-d`: Especifica la base de datos de destino donde se restaurará el respaldo.

2. **Restaurar un respaldo en formato SQL plano:**
   ```bash
   psql -U usuario -W -d nombre_base_de_datos -f respaldo.sql
   ```

#### **Enlace a la documentación oficial:**
[Documentación oficial de Restore en PostgreSQL](https://www.postgresql.org/docs/current/backup-dump.html)

---

# 
---

### **Creación de un Servidor de Réplica en PostgreSQL**<a name="601"></a>

La replicación en PostgreSQL permite tener una copia exacta de una base de datos en otro servidor, lo cual es útil para mejorar la disponibilidad, escalabilidad y seguridad de tus datos. PostgreSQL soporta la replicación en caliente, donde la réplica puede ser usada para consultas de solo lectura.

### **1. Configuración del Servidor Primario (Master)**<a name="602"></a>

El servidor primario es la base de datos original que será replicada. Debes configurarlo para permitir la replicación.

#### **Pasos:**

1. **Editar el archivo de configuración `postgresql.conf`:**
   Abre el archivo `postgresql.conf` en el servidor primario y habilita las siguientes configuraciones:
   ```bash
   wal_level = replica
   max_wal_senders = 3
   wal_keep_size = 16MB
   archive_mode = on
   archive_command = 'cp %p /path_to_archive/%f'
   ```

2. **Editar el archivo `pg_hba.conf`:**
   Este archivo se utiliza para controlar el acceso al servidor. Añade una línea para permitir la replicación desde el servidor de réplica:
   ```bash
   host    replication     replicator     192.168.1.100/32     md5
   ```
   Donde:
   - `replicator` es el nombre del usuario que tendrá permisos de replicación.
   - `192.168.1.100` es la IP del servidor de réplica.

3. **Crear un usuario para la replicación:**
   Debes crear un usuario que tenga permisos de replicación:
   ```sql
   CREATE USER replicator REPLICATION LOGIN ENCRYPTED PASSWORD 'password';
   ```

4. **Reiniciar el servidor PostgreSQL:**
   Después de hacer estos cambios, reinicia el servidor para que los cambios surtan efecto:
   ```bash
   sudo systemctl restart postgresql
   ```

---

### **2. Configuración del Servidor de Réplica (Slave)**<a name="603"></a>

El servidor de réplica recibirá las actualizaciones del servidor primario y mantendrá una copia exacta de la base de datos.

#### **Pasos:**

1. **Hacer una copia base del servidor primario:**
   En el servidor de réplica, utiliza `pg_basebackup` para hacer una copia base del servidor primario:
   ```bash
   pg_basebackup -h 192.168.1.1 -D /var/lib/postgresql/12/main -U replicator -P -R
   ```
   Donde:
   - `192.168.1.1` es la IP del servidor primario.
   - `/var/lib/postgresql/12/main` es el directorio de datos del servidor de réplica.
   - `-R` crea el archivo `recovery.conf` automáticamente.

2. **Configurar `recovery.conf`:**
   Si no utilizaste la opción `-R`, debes crear manualmente el archivo `recovery.conf` en el directorio de datos del servidor de réplica con el siguiente contenido:
   ```bash
   standby_mode = 'on'
   primary_conninfo = 'host=192.168.1.1 port=5432 user=replicator password=password'
   trigger_file = '/tmp/failover.trigger'
   ```

3. **Iniciar el servidor de réplica:**
   Una vez que la configuración está completa, inicia el servidor PostgreSQL en el servidor de réplica:
   ```bash
   sudo systemctl start postgresql
   ```

---

### **3. Verificación de la Replicación**<a name="604"></a>

Para verificar que la replicación está funcionando correctamente, puedes utilizar las siguientes consultas:

1. **Verificar el estado de la replicación en el servidor primario:**
   ```sql
   SELECT * FROM pg_stat_replication;
   ```

   Este comando te mostrará información sobre las conexiones de replicación activas.

2. **Verificar que el servidor de réplica está en modo de solo lectura:**
   En el servidor de réplica, intenta realizar una operación de escritura. Debería fallar, indicando que el servidor está en modo de solo lectura:
   ```sql
   INSERT INTO test_table VALUES (1); -- Esto debería fallar en el servidor de réplica
   ```

---

### **4. Promoción del Servidor de Réplica a Primario**<a name="605"></a>

En caso de que el servidor primario falle, puedes promover el servidor de réplica a primario usando el archivo de trigger configurado en `recovery.conf`.

1. **Crear el archivo de trigger:**
   ```bash
   touch /tmp/failover.trigger
   ```

   Esto provocará que el servidor de réplica se convierta en primario y acepte operaciones de escritura.




---


---


## 2.- Eliminarlo de la base de datos de MI<a name="eliminarmi"></a>

<img src="https://www.consolidatedcredit.org/es/wp-content/uploads/2018/11/Fotolia_251139041_Subscription_Monthly_M-l%C3%ADmites-de-las-tarjetas-de-cr%C3%A9dito.jpg?format=jpgname=large" alt="JuveR" width="800px">





realizar busqueda de los registros a eliminar via base de datos sobre las , esto para el tema de tarjetas y cobros...

***para nuestro caso , realizamos una identificacion de los registros que se deben eliminar,  luego de esto solo debemos sustituir la instruccion `Select` por `Delete`*** 

###  Crear una tabla temporal para almacenar los números de teléfono
~~~sql
CREATE TEMP TABLE phone_numbers (
    phone_number VARCHAR(15)
);

-- Insertar los números de teléfono en la tabla temporal
-- Insertar los números de teléfono en la tabla temporal
INSERT INTO phone_numbers (phone_number)
VALUES
('8099025098'),
('8297789870'),
('8294520143'),
('8492858549'),
('8094036836'),
('8496205493'),
('8098798911'),
('8295150272'),
('8097040276'),
('8296479274'),
('8098913562'),
('8296809960'),
('8294753040'),
('8297832211'),
('8296801452'),
('8494751180'),
('8097159229'),
('8094374420'),
('8293044095'),
('8498531539'),
('8295647826'),
('8298276602'),
('8096068851'),
('8299411700'),
('8094790184'),
('8096530240'),
('8093832412'),
('8093501666'),
('8093081666'),
('8297403111'),
('8292288476'),
('8292320272'),
('8293132025'),
('8094441165'),
('8096548255'),
('8098484961'),
('8099660702'),
('8297669821'),
('8297054444'),
('8096607191'),
('8299147925'),
('8295318561'),
('8299028202'),
('8494060177'),
('8494802751'),
('8097790731'),
('8295154825'),
('8293252198'),
('8493572994'),
('8293512043'),
('8295910395'),
('8295643043'),
('8293461003'),
('8293961577'),
('8297669821'),
('8493625741'),
('8297477982'),
('8098814918'),
('8298613820'),
('8292994451'),
('8097632333'),
('8097566207'),
('8297209053'),
('8097737355'),
('8099020282'),
('8099628332'),
('8298743154');

~~~


###  Seleccionar los registros de las tablas relacionadas
##  Consulta 1: PRE_GCSCUSTOMER_ENROLLMENT_M


-- Verificar información en PRE_GCSCUSTOMER_ENROLLMENT_M
~~~sql
-- Verificar información en PRE_GCSCUSTOMER_ENROLLMENT_M
SELECT *
FROM PRE_GCSCUSTOMER_ENROLLMENT_M
WHERE MSISDN IN ( 
      SELECT phone_number FROM phone_numbers 
      );

~~~

## Consulta 2: R_GCSCUSTOMER_FUNDING_ACCT_MP
-- Verificar información en R_GCSCUSTOMER_FUNDING_ACCT_MP

~~~sql
-- Verificar información en R_GCSCUSTOMER_FUNDING_ACCT_MP
SELECT *
FROM R_GCSCUSTOMER_FUNDING_ACCT_MP
WHERE MSISDN IN ( 
      SELECT phone_number FROM phone_numbers
      
      );
~~~

## Consulta 3: R_GCSCUSTOMER_ACCOUNT_M
-- Verificar información en R_GCSCUSTOMER_ACCOUNT_M

~~~sql
-- Verificar información en R_GCSCUSTOMER_ACCOUNT_M
-- Verificar información en R_GCSCUSTOMER_ACCOUNT_M
SELECT *
FROM R_GCSCUSTOMER_ACCOUNT_M
WHERE 
gcs_account_id in (
SELECT gcs_account_id
FROM R_GCSCUSTOMER_FUNDING_ACCT_MP
WHERE MSISDN IN ( 
      SELECT phone_number FROM phone_numbers
      
      )
      
      );

~~~

### 3.- En el servidor de VCASH

Este es un comando `curl` que realiza una operación de desvinculación mediante una solicitud HTTP `DELETE`. No es posible convertir este comando directamente en una consulta `SELECT` porque es una operación en un servicio externo. Sin embargo, podrías intentar verificar la existencia del recurso o realizar un `GET` si el servicio ofrece un endpoint para consultar la información antes de eliminarla.


---

Aquí tienes la documentación con un índice que te permitirá navegar fácilmente a cada sección en tu repositorio de GitHub.

---


---

## Descripción del Código

Este conjunto de consultas SQL está diseñado para abordar dos retos específicos en una base de datos de ejemplo denominada `platzi.alumnos`. El código cubre dos escenarios:

1. Seleccionar los primeros 5 registros de la tabla sin tener en cuenta el campo `ID`.
2. Encontrar la segunda colegiatura más alta y todos los alumnos que tienen esa misma colegiatura.

Cada bloque de código ofrece diferentes enfoques para resolver estos problemas, utilizando funciones como `FETCH`, `LIMIT`, subconsultas, funciones de ventana, y `JOIN`.

---

## 1. Seleccionar los Primeros 5 Registros

Este reto implica seleccionar los primeros 5 registros de la tabla `platzi.alumnos` sin contar con el campo `ID`.

### a) Usando `FETCH FIRST`

```sql
SELECT *
FROM platzi.alumnos
FETCH FIRST 5 ROWS ONLY;
```

- **Explicación:** La cláusula `FETCH FIRST 5 ROWS ONLY` limita el número de filas devueltas a las primeras 5. Esta es una forma estándar y eficiente de realizar esta tarea en bases de datos compatibles con SQL ANSI.

### b) Usando `LIMIT`

```sql
SELECT *
FROM platzi.alumnos
LIMIT 5;
```

- **Explicación:** La cláusula `LIMIT` especifica directamente cuántas filas se deben devolver. Este es el enfoque más común en sistemas como PostgreSQL y MySQL para limitar resultados.

### c) Usando Subquery y Función de Ventana

```sql
SELECT *
FROM (
    SELECT ROW_NUMBER() OVER() AS row_id, *
    FROM platzi.alumnos
) AS alumnos_with_row_num
WHERE row_id <= 5;
```

- **Explicación:** En este enfoque, se utiliza la función de ventana `ROW_NUMBER()` para asignar un número de fila a cada registro. Luego, se filtran los primeros 5 registros basados en este número. Este método es útil cuando necesitas un control más detallado sobre el orden de las filas o cuando trabajas en escenarios complejos.

---

## 2. Encontrar la Segunda Colegiatura Más Alta

Este reto implica encontrar la segunda colegiatura más alta en la tabla `platzi.alumnos` y luego listar a todos los alumnos que tienen esa colegiatura.

### a) Contar por `JOIN` entre las Tablas

```sql
SELECT DISTINCT colegiatura
FROM platzi.alumnos a1
WHERE 2 = (
    SELECT COUNT(DISTINCT colegiatura)
    FROM platzi.alumnos a2
    WHERE a1.colegiatura <= a2.colegiatura
);
```

- **Explicación:** Este enfoque utiliza una subconsulta correlacionada para contar cuántas colegiaturas distintas son mayores o iguales a la colegiatura actual. La cláusula `WHERE 2=` asegura que se selecciona la segunda colegiatura más alta.

### b) Usando `LIMIT` con `OFFSET`

```sql
SELECT DISTINCT colegiatura, tutor_id
FROM platzi.alumnos
WHERE tutor_id = 20
ORDER BY colegiatura DESC
LIMIT 1 OFFSET 1;
```

- **Explicación:** Este enfoque es directo. Se ordenan las colegiaturas en orden descendente y se utiliza `LIMIT 1 OFFSET 1` para seleccionar la segunda colegiatura más alta. Es sencillo y eficiente cuando se quiere obtener un solo valor.

### c) `JOIN` con Subconsulta

```sql
SELECT *
FROM platzi.alumnos AS datos_alumnos
INNER JOIN (
    SELECT DISTINCT colegiatura
    FROM platzi.alumnos
    WHERE tutor_id = 20
    ORDER BY colegiatura DESC
    LIMIT 1 OFFSET 1
) AS segunda_mayor_colegiatura
ON datos_alumnos.colegiatura = segunda_mayor_colegiatura.colegiatura;
```

- **Explicación:** Aquí se usa una subconsulta para encontrar la segunda colegiatura más alta y luego se realiza un `JOIN` con la tabla original para obtener todos los registros que coincidan con esa colegiatura.

### d) Subquery en `WHERE`

```sql
SELECT *
FROM platzi.alumnos AS datos_alumnos
WHERE colegiatura = (
    SELECT DISTINCT colegiatura
    FROM platzi.alumnos
    WHERE tutor_id = 20
    ORDER BY colegiatura DESC
    LIMIT 1 OFFSET 1;
);
```

- **Explicación:** En este enfoque, se utiliza una subconsulta dentro de la cláusula `WHERE` para filtrar los alumnos cuya colegiatura es igual a la segunda más alta. Este método es simple y efectivo cuando necesitas una solución rápida basada en una sola subconsulta.

---

## Conclusión

Estas consultas muestran diferentes formas de abordar problemas comunes en SQL, desde la selección de un número limitado de registros hasta la identificación de valores específicos dentro de un conjunto de datos. La elección del enfoque adecuado depende del contexto y las capacidades del motor de base de datos que se esté utilizando.

En tu repositorio de GitHub, estas consultas pueden ser útiles como referencia para desarrolladores o administradores de bases de datos que busquen soluciones prácticas a retos similares.

---


Aquí tienes la documentación completa para los nuevos retos con un índice que te permitirá navegar fácilmente en tu repositorio de GitHub.

---


## Descripción del Código

Este conjunto de consultas SQL aborda dos retos adicionales relacionados con la manipulación de datos en la base de datos `platzi.alumnos`:

1. Seleccionar resultados que no se encuentran en un conjunto específico de valores o registros.
2. Extraer partes de una fecha, como el año, el mes o el día, desde un campo de fecha.

Cada bloque de código ofrece diferentes enfoques para resolver estos problemas, utilizando operadores como `NOT IN`, funciones de ventana, y funciones de manipulación de fechas como `EXTRACT` y `DATE_PART`.

---

## 1. Seleccionar Resultados que No se Encuentran en un Set

Este reto implica seleccionar registros que no están presentes en un conjunto de valores específicos. A continuación se muestran dos enfoques diferentes para resolver este problema.

### a) Usando `NOT IN` con un Array

```sql
SELECT  *
FROM (
    SELECT ROW_NUMBER() OVER() AS row_id, *
    FROM platzi.alumnos
) AS alumnos_with_row_num
WHERE row_id NOT IN (1, 2, 3, 4, 5);
```

- **Explicación:** En este enfoque, se utiliza la función de ventana `ROW_NUMBER()` para asignar un número de fila a cada registro. Luego, se seleccionan los registros cuyo `row_id` no está en el conjunto `(1, 2, 3, 4, 5)` utilizando el operador `NOT IN`. Este método es útil cuando deseas excluir un conjunto específico de registros basados en un índice de fila.

### b) Usando `NOT IN` con una Subquery

```sql
SELECT  *
FROM platzi.alumnos
WHERE id NOT IN (
    SELECT id
    FROM platzi.alumnos
    WHERE tutor_id = 30
);
```

- **Explicación:** Este enfoque utiliza una subconsulta para seleccionar todos los `id` de alumnos con `tutor_id = 30`. Luego, en la consulta principal, se seleccionan todos los registros cuya `id` no está presente en el conjunto devuelto por la subconsulta. Este método es ideal cuando deseas excluir registros basados en criterios específicos de otra consulta.

---

## 2. Extraer Partes de una Fecha

Este reto implica extraer partes individuales de un campo de fecha, como el año, el mes y el día. A continuación se presentan dos formas de hacerlo utilizando las funciones `EXTRACT` y `DATE_PART`.

### a) Usando `EXTRACT`

```sql
SELECT EXTRACT(YEAR FROM fecha_incorporacion) AS anio_incorporacion
FROM platzi.alumnos;
```

- **Explicación:** La función `EXTRACT` permite extraer una parte específica de un campo de fecha. En este caso, se extrae el año de la columna `fecha_incorporacion`. Es compatible con varios sistemas de bases de datos, como PostgreSQL y Oracle.

### b) Usando `DATE_PART`

```sql
SELECT DATE_PART('YEAR', fecha_incorporacion) AS anio_incorporacion
FROM platzi.alumnos;
```

```sql
SELECT  DATE_PART('YEAR', fecha_incorporacion) AS anio_incorporacion,
        DATE_PART('MONTH', fecha_incorporacion) AS mes_incorporacion,
        DATE_PART('DAY', fecha_incorporacion) AS dia_incorporacion
FROM platzi.alumnos;
```

- **Explicación:** La función `DATE_PART` es similar a `EXTRACT`, pero se utiliza con una sintaxis diferente, específica de PostgreSQL. En estos ejemplos, se extraen el año, el mes y el día de la columna `fecha_incorporacion`. Este enfoque es útil cuando necesitas trabajar con partes específicas de una fecha en varias columnas al mismo tiempo.

---

## Conclusión

Estas consultas demuestran diferentes enfoques para manipular conjuntos de datos y trabajar con fechas en SQL. La elección entre `NOT IN` con arrays o subconsultas, y entre `EXTRACT` o `DATE_PART` para manipular fechas, depende del motor de base de datos y de las necesidades específicas de la consulta.

Estas soluciones pueden ser útiles como referencia en tu repositorio de GitHub para resolver problemas comunes de manipulación de datos.

---

Aquí tienes la continuación de la documentación, centrada en operaciones y extracción de datos de tiempo, horas, minutos y segundos, utilizando la misma tabla `platzi.alumnos`.

---



## Descripción del Código

Este conjunto de consultas SQL se amplía con operaciones y extracción de tiempos (horas, minutos y segundos) utilizando la tabla `platzi.alumnos`. Veremos cómo extraer componentes específicos de una columna de tipo `time` o `timestamp`, así como realizar operaciones con intervalos de tiempo.

---

## 3. Operaciones y Extracción de Tiempos

En esta sección, trabajaremos con tiempos (horas, minutos y segundos), realizando extracciones y operaciones en la columna `hora_incorporacion` de la tabla `platzi.alumnos`.

### a) Extraer Hora, Minutos y Segundos

Este reto consiste en extraer la hora, los minutos y los segundos de un campo de tipo `time` o `timestamp`.

#### Usando `EXTRACT`

```sql
SELECT EXTRACT(HOUR FROM hora_incorporacion) AS hora,
       EXTRACT(MINUTE FROM hora_incorporacion) AS minutos,
       EXTRACT(SECOND FROM hora_incorporacion) AS segundos
FROM platzi.alumnos;
```

- **Explicación:** En este caso, usamos la función `EXTRACT` para extraer la hora, los minutos y los segundos de la columna `hora_incorporacion`. Este método es útil cuando se necesita trabajar con componentes individuales de un campo de tiempo.

#### Usando `DATE_PART`

```sql
SELECT DATE_PART('HOUR', hora_incorporacion) AS hora,
       DATE_PART('MINUTE', hora_incorporacion) AS minutos,
       DATE_PART('SECOND', hora_incorporacion) AS segundos
FROM platzi.alumnos;
```

- **Explicación:** Similar a `EXTRACT`, `DATE_PART` extrae partes específicas de una columna de tiempo o fecha. Aquí, se usa para obtener la hora, los minutos y los segundos de la columna `hora_incorporacion`.

---

### b) Sumar o Restar Intervalos de Tiempo

Este reto implica sumar o restar intervalos de tiempo a una columna de tipo `time` o `timestamp`.

#### Sumar Intervalos de Tiempo

```sql
SELECT hora_incorporacion,
       hora_incorporacion + INTERVAL '1 HOUR' AS hora_mas_una_hora
FROM platzi.alumnos;
```

- **Explicación:** Esta consulta suma un intervalo de una hora a la columna `hora_incorporacion`. Los intervalos pueden ser especificados en diferentes unidades, como minutos, segundos, días, etc.

#### Restar Intervalos de Tiempo

```sql
SELECT hora_incorporacion,
       hora_incorporacion - INTERVAL '30 MINUTES' AS hora_menos_treinta_minutos
FROM platzi.alumnos;
```

- **Explicación:** Aquí, restamos 30 minutos de la columna `hora_incorporacion`, lo que es útil cuando se necesita ajustar tiempos de forma dinámica.

---

### c) Calcular Diferencia entre Tiempos

Este reto consiste en calcular la diferencia entre dos columnas de tipo `time` o `timestamp`.

#### Diferencia en Horas

```sql
SELECT hora_incorporacion, hora_salida,
       EXTRACT(EPOCH FROM (hora_salida - hora_incorporacion)) / 3600 AS diferencia_horas
FROM platzi.alumnos;
```

- **Explicación:** En esta consulta, calculamos la diferencia entre `hora_salida` y `hora_incorporacion` en horas. Primero, se extrae la diferencia en segundos (`EPOCH`) y luego se divide por 3600 para obtener el resultado en horas.

#### Diferencia en Minutos

```sql
SELECT hora_incorporacion, hora_salida,
       EXTRACT(EPOCH FROM (hora_salida - hora_incorporacion)) / 60 AS diferencia_minutos
FROM platzi.alumnos;
```

- **Explicación:** Similar al cálculo anterior, pero aquí obtenemos la diferencia en minutos dividiendo el valor en segundos por 60.

---

## Conclusión

Estas consultas amplían las operaciones sobre campos de tiempo, mostrando cómo extraer partes específicas de una columna de tiempo, sumar o restar intervalos, y calcular diferencias entre tiempos. Estas soluciones son útiles para manejar datos temporales en sistemas que requieren un seguimiento detallado de horas y fechas.




# No Existe nada debajo de esta linea.
