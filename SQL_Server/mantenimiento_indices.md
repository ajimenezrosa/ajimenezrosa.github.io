#### **3. Mantenimiento de Índices**
- 3.1 [Información general de mantenimiento de índices en SQL Server](#inf_mant_indices)  
    - 3.1.1 [Localizar tablas sin `Clustered Index`](#tablasinclusterindex)  
    - 3.1.2 [Detección de índices no utilizados – Parte 1](#indicesnoutilizados)  
    - 3.1.3 [Tablas de montón](#tablasmonton)  
    - 3.1.4 [Detección de índices no utilizados – Parte 2](#indicesnoutilizados2)  
    - 3.1.5 [Posibles índices NC incorrectos](#escrituraslecturas)  
    - 3.1.6 [Identificación de índices duplicados](#indicesduplicados)  
    - 3.1.7 [Conceptos básicos del diseño de índices](#disenoindices)  
    - 3.1.8 [Tareas y consideraciones del diseño de índices](#tareadisind)  
    - 3.1.9 [Eliminar y recrear índices de forma ONLINE=ON](#6.8)  
    - 3.1.10 [Listado de los índices en una base de datos](#6.9)  
    - 3.1.11 [Missing Index Script](#missinindex)  
    - 3.1.12 [Defragmentación](#desfragmentacionalrescate)  
    - 3.1.13 [Procedimiento `MeasureIndexImprovement`](#MeasureIndexImprovement)  
- 3.2 [Evaluación de Índices en SQL Server](#3113)  
- 3.3 [Consulta para identificar el Filegroup de los índices en SQL Server](#3.3)
    <!-- - 3.1.13 [Evaluación de Índices en SQL Server](#3113) -->
#### Documentación sobre Consultas de Índices en SQL Server

##### Índice

- [Introducción](#introducci%C3%B3n)
- [Identificación de Índices Innecesarios](#identificaci%C3%B3n-de-%C3%ADndices-innecesarios)
- [Detalles de los Índices en las Tablas](#detalles-de-los-%C3%ADndices-en-las-tablas)
- [Comparación y Agrupación de Índices](#comparaci%C3%B3n-y-agrupaci%C3%B3n-de-%C3%ADndices)
- [Conclusión](#conclusi%C3%B3n)
---


# Información general de mantenimiento del índice SQL<a name="inf_mant_indices"><a/>

[![IMAGE ALT TEXT](https://learn.microsoft.com/es-es/sql/relational-databases/media/sql-server-index-design-guide/hash-index-buckets.png?view=sql-server-ver16)

#### El problema en un mantenimiento de índices y del rendimiento es la fragmentación del índice. Es posible que ya estés familiarizado con el término de fragmentación del sistema operativo y del disco duro. La fragmentación es lo que arruina nuestros índices y, claro, los discos duros en el entorno del sistema operativo (No tanto desde que salen las unidades físicamente). A medida que los datos entran y salen, se modifica, etc. las cosas deben moverse. Esto implica una gran cantidad de actividad de lecturas y escrituras en nuestros discos duros.

#### La fragmentación es básicamente el poder almacenar datos de forma no contigua en el disco. Entonces, la idea principal es de intentar de mantenerlo de forma contigua (en secuencia) ya que, si los datos se almacenan de manera contigua, es mucho menos el trabajo para nuestro sistema operativo y el subsistema del I/O ya que sólo se deben manejar las cosas de manera secuencial. Por otro lado, cuando los datos están en desorden, entonces el sistema operativo debe saltar por diferentes lugares. Siempre me gusta explicar las cosas usando una analogía del mundo real y para los índices, siempre uso una agenda normal o una guía telefónica para poder explicar la recuperación de datos ya es mucho más fácil de poder entender. Pero para la desfragmentación, yo creo que el mejor ejemplo sería el de un estante para libros.


# Obtener los tiempos de duración de un Job en secuancia horaria
![](https://docs.microsoft.com/es-es/sql/database-engine/availability-groups/windows/media/always-onag-datasynchronization.gif?view=sql-server-ver15)
#### Esta consulta, sirve para mostrar en forma de columnas, hora a hora, el tiempo de ejecucion de un Job determinado


# 

# Procedimiento para localizar tablas sin Closther Index en las bases de datos.<a name="tablasinclusterindex"></a>

<img src="https://s33046.pcdn.co/wp-content/uploads/2018/11/word-image-339.png?format=jpg&name=large" alt="JuveR" width="600px">

# 
~~~sql
/*
Alejandro Jimenez lunes 4 de Febrero 2019
*/

DECLARE @DataBaseNema varchar(20) = 'INABIMA'

SELECT TOP ( 10000 ) o.name, ius.user_seeks, ius.user_scans, ius.user_lookups, ius.user_updates --, *
FROM sys.indexes i
INNER JOIN sys.objects o
    ON i.object_id = o.object_id
INNER JOIN sys.partitions p
    ON  i.object_id = p.object_id
    AND i.index_id = p.index_id
INNER JOIN sys.databases sd
    ON sd.name =@DataBaseNema
LEFT OUTER JOIN sys.dm_db_index_usage_stats ius
    ON  i.object_id = ius.object_id
    AND i.index_id = ius.index_id
    AND ius.database_id = sd.database_id
WHERE i.type_desc = 'HEAP'
AND   COALESCE(ius.user_seeks, ius.user_scans, ius.user_lookups, ius.user_updates) IS NOT NULL
AND   (ius.user_seeks + ius.user_scans + ius.user_lookups + ius.user_updates) > 0
AND   sd.name <> 'tempdb'
AND   o.is_ms_shipped = 0
AND   o.type <> 'S'
ORDER BY (ius.user_seeks + ius.user_scans + ius.user_lookups + ius.user_updates) DESC, o.name;
~~~

### Por supuesto, aquí tienes un ejemplo de una consulta SQL que busca las tablas que no tienen una clave primaria definida en una base de datos:

~~~sql
--USE nombre_de_tu_base_de_datos;
SELECT
    t.name AS 'Nombre de la tabla'
FROM
    sys.tables t
WHERE
    NOT EXISTS (
        SELECT 1
        FROM sys.indexes i
        WHERE i.object_id = t.object_id AND i.is_primary_key = 1
    )
ORDER BY
    t.name;
~~~


# 
### La responsabilidad más importante de un Administrador de bases de datos es el poder garantizar que las bases de datos trabajen de una forma óptima. La manera más eficiente de hacerlo es por medio de índices. Los índices en SQL son uno de los recursos más efectivos a la hora de obtener una ganancia en el rendimiento. Sin embargo, lo que sucede con los índices es que estos se deterioran con el tiempo.
### -- Missing Index Script<a name="missinindex"></a>
# 
~~~sql
-- Missing Index Script
-- Original Author: Pinal Dave 
SELECT TOP 25
dm_mid.database_id AS DatabaseID,
dm_migs.avg_user_impact*(dm_migs.user_seeks+dm_migs.user_scans) Avg_Estimated_Impact,
dm_migs.last_user_seek AS Last_User_Seek,
OBJECT_NAME(dm_mid.OBJECT_ID,dm_mid.database_id) AS [TableName],
'CREATE INDEX [IX_' + OBJECT_NAME(dm_mid.OBJECT_ID,dm_mid.database_id) + '_'
+ REPLACE(REPLACE(REPLACE(ISNULL(dm_mid.equality_columns,''),', ','_'),'[',''),']','') 
+ CASE
WHEN dm_mid.equality_columns IS NOT NULL
AND dm_mid.inequality_columns IS NOT NULL THEN '_'
ELSE ''
END
+ REPLACE(REPLACE(REPLACE(ISNULL(dm_mid.inequality_columns,''),', ','_'),'[',''),']','')
+ ']'
+ ' ON ' + dm_mid.statement
+ ' (' + ISNULL (dm_mid.equality_columns,'')
+ CASE WHEN dm_mid.equality_columns IS NOT NULL AND dm_mid.inequality_columns 
IS NOT NULL THEN ',' ELSE
'' END
+ ISNULL (dm_mid.inequality_columns, '')
+ ')'
+ ISNULL (' INCLUDE (' + dm_mid.included_columns + ')', '') AS Create_Statement
FROM sys.dm_db_missing_index_groups dm_mig
INNER JOIN sys.dm_db_missing_index_group_stats dm_migs
ON dm_migs.group_handle = dm_mig.index_group_handle
INNER JOIN sys.dm_db_missing_index_details dm_mid
ON dm_mig.index_handle = dm_mid.index_handle
WHERE dm_mid.database_ID = DB_ID()
ORDER BY Avg_Estimated_Impact DESC
GO
~~~
# 
#### Missing index para Servidores AlwaysOn.
#### Solo funciona con Sql Server Enterprise Edition
~~~sql
-- Missing Index Script
-- Original Author: Pinal Dave 
SELECT TOP 25
dm_mid.database_id AS DatabaseID,
dm_migs.avg_user_impact*(dm_migs.user_seeks+dm_migs.user_scans) Avg_Estimated_Impact,
dm_migs.last_user_seek AS Last_User_Seek,
OBJECT_NAME(dm_mid.OBJECT_ID,dm_mid.database_id) AS [TableName],
'CREATE INDEX [IX_' + OBJECT_NAME(dm_mid.OBJECT_ID,dm_mid.database_id) + '_'
+ REPLACE(REPLACE(REPLACE(ISNULL(dm_mid.equality_columns,''),', ','_'),'[',''),']','') 
+ CASE
WHEN dm_mid.equality_columns IS NOT NULL
AND dm_mid.inequality_columns IS NOT NULL THEN '_'
ELSE ''
END
+ REPLACE(REPLACE(REPLACE(ISNULL(dm_mid.inequality_columns,''),', ','_'),'[',''),']','')
+ ']'
+ ' ON ' + dm_mid.statement
+ ' (' + ISNULL (dm_mid.equality_columns,'')
+ CASE WHEN dm_mid.equality_columns IS NOT NULL AND dm_mid.inequality_columns 
IS NOT NULL THEN ',' ELSE
'' END
+ ISNULL (dm_mid.inequality_columns, '')
+ ')'
+ ISNULL (' INCLUDE (' + dm_mid.included_columns + ')', ''+' WITH (ONLINE = ON);' )  AS Create_Statement
FROM sys.dm_db_missing_index_groups dm_mig
INNER JOIN sys.dm_db_missing_index_group_stats dm_migs
ON dm_migs.group_handle = dm_mig.index_group_handle
INNER JOIN sys.dm_db_missing_index_details dm_mid
ON dm_mig.index_handle = dm_mid.index_handle
WHERE dm_mid.database_ID = DB_ID()
ORDER BY Avg_Estimated_Impact DESC
GO
~~~

# 
## Creacion de Indices Filtrados, Usando N cores del servidor
#### Sí, en SQL Server, puedes crear un índice que utilice una cantidad específica de núcleos (cores) para mejorar el rendimiento de las consultas. Esto se conoce como un "índice particionado" o un "índice filtrado". Sin embargo, es importante destacar que SQL Server generalmente gestiona la asignación de recursos de manera automática y utiliza múltiples núcleos para procesar consultas de manera eficiente sin que necesites especificar la cantidad de núcleos en un índice.

#### Dicho esto, puedes crear un índice particionado o filtrado para mejorar el rendimiento en situaciones específicas, pero esto no implica la asignación manual de núcleos. A continuación, te explico cómo crear estos tipos de índices:

1. **Índice Particionado:** Un índice particionado divide una tabla en varias particiones y permite que SQL Server almacene y administre los datos de manera más eficiente. Para crear un índice particionado, primero debes definir una función de partición y esquema de partición en tu base de datos y luego crear el índice utilizando estas particiones. No necesitas especificar la cantidad de núcleos.

```sql
-- Ejemplo de creación de un índice particionado en SQL Server
CREATE PARTITION FUNCTION MiFuncionParticion ()
AS RANGE LEFT FOR VALUES (1, 2, 3);

CREATE PARTITION SCHEME MiEsquemaParticion
AS PARTITION MiFuncionParticion
ALL TO ([PRIMARY]);

CREATE CLUSTERED INDEX MiIndiceParticionado
ON MiTabla (Columna)
ON MiEsquemaParticion(Columna);
```

2. **Índice Filtrado:** Un índice filtrado es un índice que solo incluye un subconjunto de filas de la tabla. Esto puede ayudar a mejorar el rendimiento en consultas específicas si solo necesitas acceder a una parte de los datos.

```sql
-- Ejemplo de creación de un índice filtrado en SQL Server
CREATE NONCLUSTERED INDEX MiIndiceFiltrado
ON MiTabla (Columna)
WHERE Condición;
```

#### Ten en cuenta que la gestión de núcleos y recursos en SQL Server se realiza automáticamente a nivel del motor de base de datos. Si experimentas problemas de rendimiento, en lugar de intentar asignar núcleos manualmente, es recomendable realizar un ajuste de consultas, revisar la configuración del servidor y utilizar herramientas de monitoreo para identificar cuellos de botella y optimizar el rendimiento.


# 

# Procedimiento MeasureIndexImprovement<a name="MeasureIndexImprovement"></a>

## Descripción
El procedimiento almacenado `MeasureIndexImprovement` mide la mejora en el uso de índices en una base de datos de SQL Server entre dos fechas especificadas. Recopila datos sobre el uso de índices al inicio y al final del período dado y compara los resultados para mostrar la mejora en búsquedas (`seeks`), escaneos (`scans`), consultas (`lookups`) y actualizaciones (`updates`) para cada índice.

## Parámetros
- `@StartDate DATETIME`: La fecha de inicio para medir el uso de índices.
- `@EndDate DATETIME`: La fecha de fin para medir el uso de índices.

## Funcionalidad
1. **Recopilación de Datos Iniciales**: Recopila estadísticas de uso de índices en la fecha de inicio y las almacena en una tabla temporal.
2. **Recopilación de Datos Finales**: Recopila estadísticas de uso de índices en la fecha de fin y las almacena en otra tabla temporal.
3. **Comparación**: Compara los datos iniciales y finales para calcular la mejora en búsquedas, escaneos, consultas y actualizaciones para cada índice.
4. **Salida**: Muestra los resultados de la comparación, mostrando el nombre de la base de datos, nombre de la tabla, ID del índice, nombre del índice, estadísticas de uso iniciales, estadísticas de uso finales y la mejora en cada estadística.

## Código SQL

~~~sql
CREATE PROCEDURE MeasureIndexImprovement
    @StartDate DATETIME,
    @EndDate DATETIME
AS
BEGIN
    -- Crea una tabla temporal para almacenar el uso inicial de los índices
    CREATE TABLE #InitialIndexUsageStats (
        DatabaseName NVARCHAR(128),
        TableName NVARCHAR(128),
        IndexID INT,
        IndexName NVARCHAR(128),
        UserSeeks BIGINT,
        UserScans BIGINT,
        UserLookups BIGINT,
        UserUpdates BIGINT
    );

    -- Recopila datos sobre el uso de índices en la fecha de inicio
    INSERT INTO #InitialIndexUsageStats
    SELECT 
        DB_NAME(s.database_id) AS DatabaseName,
        OBJECT_NAME(s.object_id) AS TableName,
        s.index_id AS IndexID,
        i.name AS IndexName,
        s.user_seeks AS UserSeeks,
        s.user_scans AS UserScans,
        s.user_lookups AS UserLookups,
        s.user_updates AS UserUpdates
    FROM 
        sys.dm_db_index_usage_stats s
    INNER JOIN 
        sys.indexes i ON s.object_id = i.object_id AND s.index_id = i.index_id
    WHERE 
        s.database_id = DB_ID() 
        AND s.last_user_seek >= @StartDate
        AND s.last_user_seek < DATEADD(day, 1, @EndDate);

    -- Crea una tabla temporal para almacenar el uso final de los índices
    CREATE TABLE #FinalIndexUsageStats (
        DatabaseName NVARCHAR(128),
        TableName NVARCHAR(128),
        IndexID INT,
        IndexName NVARCHAR(128),
        UserSeeks BIGINT,
        UserScans BIGINT,
        UserLookups BIGINT,
        UserUpdates BIGINT
    );

    -- Recopila datos sobre el uso de índices en la fecha de fin
    INSERT INTO #FinalIndexUsageStats
    SELECT 
        DB_NAME(s.database_id) AS DatabaseName,
        OBJECT_NAME(s.object_id) AS TableName,
        s.index_id AS IndexID,
        i.name AS IndexName,
        s.user_seeks AS UserSeeks,
        s.user_scans AS UserScans,
        s.user_lookups AS UserLookups,
        s.user_updates AS UserUpdates
    FROM 
        sys.dm_db_index_usage_stats s
    INNER JOIN 
        sys.indexes i ON s.object_id = i.object_id AND s.index_id = i.index_id
    WHERE 
        s.database_id = DB_ID() 
        AND s.last_user_seek >= @EndDate
        AND s.last_user_seek < DATEADD(day, 1, @EndDate);

    -- Compara los datos antes y después de los cambios
    SELECT 
        COALESCE(initial.DatabaseName, final.DatabaseName) AS DatabaseName,
        COALESCE(initial.TableName, final.TableName) AS TableName,
        COALESCE(initial.IndexID, final.IndexID) AS IndexID,
        COALESCE(initial.IndexName, final.IndexName) AS IndexName,
        ISNULL(initial.UserSeeks, 0) AS InitialUserSeeks,
        ISNULL(final.UserSeeks, 0) AS FinalUserSeeks,
        (ISNULL(final.UserSeeks, 0) - ISNULL(initial.UserSeeks, 0)) AS ImprovementInSeeks,
        ISNULL(initial.UserScans, 0) AS InitialUserScans,
        ISNULL(final.UserScans, 0) AS FinalUserScans,
        (ISNULL(final.UserScans, 0) - ISNULL(initial.UserScans, 0)) AS ImprovementInScans,
        ISNULL(initial.UserLookups, 0) AS InitialUserLookups,
        ISNULL(final.UserLookups, 0) AS FinalUserLookups,
        (ISNULL(final.UserLookups, 0) - ISNULL(initial.UserLookups, 0)) AS ImprovementInLookups,
        ISNULL(initial.UserUpdates, 0) AS InitialUserUpdates,
        ISNULL(final.UserUpdates, 0) AS FinalUserUpdates,
        (ISNULL(final.UserUpdates, 0) - ISNULL(initial.UserUpdates, 0)) AS ImprovementInUpdates
    FROM 
        #InitialIndexUsageStats initial
    FULL OUTER JOIN 
        #FinalIndexUsageStats final
    ON 
        initial.DatabaseName = final.DatabaseName
        AND initial.TableName = final.TableName
        AND initial.IndexID = final.IndexID
    ORDER BY 
        COALESCE(initial.TableName, final.TableName), 
        COALESCE(initial.IndexID, final.IndexID);

    -- Limpia las tablas temporales
    DROP TABLE #InitialIndexUsageStats;
    DROP TABLE #FinalIndexUsageStats;
END;
GO

-- Ejecuta el procedimiento almacenado con las fechas deseadas
EXEC MeasureIndexImprovement '2024-05-01', '2024-06-28';
~~~

## Cómo Usarlo
1. Crea el procedimiento almacenado en tu base de datos de SQL Server ejecutando el código SQL proporcionado.
2. Ejecuta el procedimiento almacenado con las fechas de inicio y fin deseadas para medir la mejora en el uso de índices:
   ~~~sql
   EXEC MeasureIndexImprovement 'YYYY-MM-DD', 'YYYY-MM-DD';
   ~~~
   Reemplaza `'YYYY-MM-DD'` con las fechas de inicio y fin que desees.

## Ejemplo de Ejecución
Para medir la mejora en el uso de índices entre el 1 de mayo de 2024 y el 28 de junio de 2024:
~~~sql
EXEC MeasureIndexImprovement '2024-05-01', '2024-06-28';
~~~

Esto mostrará los resultados de la comparación, mostrando las estadísticas de uso iniciales y finales de los índices y la mejora en búsquedas, escaneos, consultas y actualizaciones para cada índice.





# Indices no Utilizados<a name="indicesnoutilizados"></a>
![](https://s33046.pcdn.co/wp-content/uploads/2018/05/word-image-103.png)
#### Es comun tambien que en dichos procesos algunas tablas (generalmente las muy usadas) acumulen una cantidad de indices y algunos no siempre son utilizados por la aplicacion. 
#### El mantener dichos indices empeora la performance de los inserts y tambien hacen demorar mas al optimizador pues tiene mas opciones para analizar.


#### Leyendo el libro Relational Database Index Design and the Optimizers pude ver cuantificado las demoras que puede ocasionar el tener indices de mas en tablas con millones de registros.

#### Por suerte los muchachos de Microsoft, en SQL Server 2005,2008,2012,2014, mejoraron muchisimo la metadata que se mantiene para ver que indices se utilizan y cuales no. Por ejemplo con la consulta
# 

~~~sql
--Indices no usados ***
SELECT 'NOUsado',object_name(i.object_id) AS ObjectName 
, i.name as IndexName 
, i.index_id 
FROM sys.indexes i 
INNER JOIN sys.objects o ON o.object_id = i.object_id
LEFT JOIN sys.dm_db_index_usage_stats s 
ON i.object_id=s.object_id AND i.index_id=s.index_id AND database_id = DB_ID() 
WHERE objectproperty(o.object_id,'IsUserTable') = 1 AND s.index_id IS NULL 
ORDER BY objectname,i.index_id,indexname ASC

~~~
# 
# 


~~~sql
DECLARE @JobName VARCHAR(255) = null -- 'TablasFechasAccesos'
  
;WITH JobHistory AS
(
  SELECT
     @@servername as ServerName,
     a.run_date
    ,a.run_time / 10000 AS [HOUR]
    ,(a.run_duration / 10000 * 60 * 60  -- Hours
     + a.run_duration % 10000 / 100 * 60    -- Minutes
     + a.run_duration % 100         -- Seconds
     ) / 60.0 AS [DurationMinutes]
  FROM
    msdb.dbo.sysjobhistory a WITH(NOLOCK)
    INNER JOIN msdb.dbo.sysjobs b WITH(NOLOCK) --Ob
    ON
      a.[job_id] = b.[job_id]
      AND( b.[name] = @JobName or @JobName is null)
      AND step_id = 0
      AND run_status = 1
)
SELECT *
FROM
  JobHistory    
  PIVOT
  ( SUM(DurationMinutes)
    FOR [HOUR] 
    IN  ([00],[01],[02],[03],[04],[05]
        ,[06],[07],[08],[09],[10],[11]
        ,[12],[13],[14],[15],[16],[17]
        ,[18],[19],[20],[21],[22],[23])
  ) AS p
~~~

# 

# Tablas de montón<a name="tablasmonton"><a/>
![](https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRVThSd-LNtk5AvCmeFjEojJJY6Z7twd_IYng&usqp=CAU)
#### Las tablas de montón son tablas que contienen índices no Agrupados. Esto significa que las filas de información en la tabla de montón, no están almacenadas en ningún orden particular en cada página de información. Además no hay un orden particular para controlar la secuencia de páginas de información, que no está unida en una lista conectada. Como resultado, recuperar información de insertar o modificar en la tabla montón será muy lento y puede ser fragmentado más fácilmente.

#### Para más información sobre tablas de montón revisar Resumen de estructura de tablas SQL Server

#### Necesitas primero identificar las tablas montón en tu base de datos y concentrarte solo en las tablas grandes, ya que el Optimizador de Consultas de SQL Server no se beneficiará de los índices creados en tablas más pequeñas. Tablas de montón pueden ser detectadas al consultar objetos sys.indexes system, en conjunción con otros sistemas de vistas de catálogo, para recuperar información significante, como se muestra en el Detectar Indices no utilizados en SQLServer<a name="indicesnoutilizados2"><a/>
# 

# Detectar Indices no utilizados en SQLServer
## Me he basado en las siguientes consultas:

#### He utilizado las siguientes consultas añado las fuentes para poder obtener más información.
#### Esta primera indica aquellos indices que no se realizan consultas de lectura solo de escritura actualizaciones y inserciones, por lo que es una sobrecarga del sistema por lo que son candidatos a ser eliminados.
# 
~~~sql
USE [tuBBDD] /* Replace with your Database Name */
GO
--TOTALLY UN-USED INDEXES
SELECT DB_NAME(s.database_id) as [DB Name], 
OBJECT_NAME(s.[object_id]) AS [Table Name]
, i.name AS [Index Name], i.index_id,
i.is_disabled, i.is_hypothetical, i.has_filter
, i.fill_factor
, i.is_unique,
s.user_updates AS [Total Writes],
(s.user_seeks + s.user_scans + s.user_lookups) AS [Total Reads],
s.user_updates - (s.user_seeks + s.user_scans + s.user_lookups) AS [Difference],
(partstats.used_page_count / 128.0) AS [IndexSizeinMB]
FROM sys.dm_db_index_usage_stats AS s WITH (NOLOCK)
INNER JOIN sys.indexes AS i WITH (NOLOCK)
ON s.[object_id] = i.[object_id]
AND s.index_id = i.index_id
AND s.database_id = DB_ID()
INNER JOIN sys.dm_db_partition_stats AS partstats
ON i.object_id = partstats.object_id AND i.index_id = partstats.index_id
WHERE OBJECTPROPERTY(s.[object_id],'IsUserTable') = 1
AND user_updates > (user_seeks + user_scans + user_lookups)
AND (s.user_lookups=0 AND s.user_scans=0 AND s.user_seeks=0)
AND i.index_id > 1
ORDER BY [Difference] DESC, [Total Writes] DESC, [Total Reads] ASC OPTION (RECOMPILE);
GO
~~~
# 
# 
#### La siguiente consulta, muestra aquellos indices que tengan mas consultas de escritura que de lectura.
#### Debes estudiar cada indice si es candidato a ser eliminado.
# 


~~~sql
USE [tuBBDD] /* Replace with your Database Name */
GO
--INDEXES WITH WRITES > READS
SELECT DB_NAME(s.database_id) as [DB Name]
, OBJECT_NAME(s.[object_id]) AS [Table Name]
, i.name AS [Index Name], i.index_id,
i.is_disabled, i.is_hypothetical
, i.has_filter, i.fill_factor, i.is_unique,
s.user_updates AS [Total Writes],
(s.user_seeks + s.user_scans + s.user_lookups) AS [Total Reads],
s.user_updates - (s.user_seeks + s.user_scans + s.user_lookups) AS [Difference],
(partstats.used_page_count / 128.0) AS [IndexSizeinMB]
FROM sys.dm_db_index_usage_stats AS s WITH (NOLOCK)
INNER JOIN sys.indexes AS i WITH (NOLOCK)
ON s.[object_id] = i.[object_id]
AND s.index_id = i.index_id
AND s.database_id = DB_ID()
INNER JOIN sys.dm_db_partition_stats AS partstats
ON i.object_id = partstats.object_id AND i.index_id = partstats.index_id
WHERE OBJECTPROPERTY(s.[object_id],'IsUserTable') = 1
AND (s.user_lookups<>0 OR s.user_scans<>0 OR s.user_seeks<>0)
AND s.user_updates > (s.user_seeks + s.user_scans + s.user_lookups)
AND i.index_id > 1
ORDER BY [Difference] DESC, [Total Writes] DESC, [Total Reads] ASC OPTION (RECOMPILE);
GO
~~~
Fuente: thesqldude.com

# 
#### Esta consulta complementa la anterior para decir que indices podrías eliminar.
#### Se debe prestar atención User Scan, User Lookup y User Update antes de eliminar el Index.
#### Si el valor de User Scan, User Lookup y User Update es alto y de User Seek bajo necesitas revisar el Indice
# 

~~~sql
-- Unused Index Script
-- Original Author: Pinal Dave 
SELECT TOP 25
o.name AS ObjectName
, i.name AS IndexName
, i.index_id AS IndexID
, dm_ius.user_seeks AS UserSeek
, dm_ius.user_scans AS UserScans
, dm_ius.user_lookups AS UserLookups
, dm_ius.user_updates AS UserUpdates
, p.TableRows
, 'DROP INDEX ' + QUOTENAME(i.name)
+ ' ON ' + QUOTENAME(s.name) + '.'
+ QUOTENAME(OBJECT_NAME(dm_ius.OBJECT_ID)) AS 'drop statement'
FROM sys.dm_db_index_usage_stats dm_ius
INNER JOIN sys.indexes i ON i.index_id = dm_ius.index_id 
AND dm_ius.OBJECT_ID = i.OBJECT_ID
INNER JOIN sys.objects o ON dm_ius.OBJECT_ID = o.OBJECT_ID
INNER JOIN sys.schemas s ON o.schema_id = s.schema_id
INNER JOIN (SELECT SUM(p.rows) TableRows, p.index_id, p.OBJECT_ID
FROM sys.partitions p GROUP BY p.index_id, p.OBJECT_ID) p
ON p.index_id = dm_ius.index_id AND dm_ius.OBJECT_ID = p.OBJECT_ID
WHERE OBJECTPROPERTY(dm_ius.OBJECT_ID,'IsUserTable') = 1
AND dm_ius.database_id = DB_ID()
AND i.type_desc = 'nonclustered'
AND i.is_primary_key = 0
AND i.is_unique_constraint = 0
ORDER BY (dm_ius.user_seeks + dm_ius.user_scans + dm_ius.user_lookups) ASC
GO
~~~
Fuente: blog.sqlauthority.com

# 

# 

~~~sql
/*
Insertado por Alejandro Jimenez 
Miercoles 27 de Enero del 2021
*/
SELECT OBJECT_NAME(IDX.object_id)  Table_Name
      , IDX.name  Index_name
      , PAR.rows  NumOfRows
      , IDX.type_desc  TypeOfIndex
FROM sys.partitions PAR
INNER JOIN sys.indexes IDX ON PAR.object_id = IDX.object_id  AND PAR.index_id = IDX.index_id AND IDX.type = 0
INNER JOIN sys.tables TBL
ON TBL.object_id = IDX.object_id and TBL.type ='U'
~~~

# 

# How Bad Are Your Indexes?<a name="badnc"><a/>

#### ** IMPORTANTE **: cada vez que considere eliminar un índice, siempre verifique a través de patrones de uso, entrevistas con usuarios, etc. que el índice es realmente "eliminable"; *no* quiere ser el que elimine un "malo" índice solo para descubrir que es necesario para la ejecución de la nómina mensual, o los informes de bonificación trimestrales, o algún otro proceso comercial crítico. Muy a menudo, los índices "malos" solo se usan periódicamente, pero son muy importantes. Una alternativa a considerar en lugar de eliminar el índice por completo es verificar si el índice se puede eliminar y luego volver a crear cuando sea necesario, pero a menudo el proceso de creación del índice incurre en demasiada sobrecarga para que esto sea viable.
#

## Posibles índices NC incorrectos<a name="escrituraslecturas"></a>
# 

~~~sql
-- Possible Bad NC Indexes (writes > reads)  (Query 47) (Bad NC Indexes)
SELECT OBJECT_NAME(s.[object_id]) AS [Table Name], i.name AS [Index Name], i.index_id,
i.is_disabled, i.is_hypothetical, i.has_filter, i.fill_factor,
user_updates AS [Total Writes], user_seeks + user_scans + user_lookups AS [Total Reads],
user_updates - (user_seeks + user_scans + user_lookups) AS [Difference]
FROM sys.dm_db_index_usage_stats AS s WITH (NOLOCK)
INNER JOIN sys.indexes AS i WITH (NOLOCK)
ON s.[object_id] = i.[object_id]
AND i.index_id = s.index_id
WHERE OBJECTPROPERTY(s.[object_id],'IsUserTable') = 1
AND s.database_id = DB_ID()
AND user_updates > (user_seeks + user_scans + user_lookups)
AND i.index_id > 1
ORDER BY [Difference] DESC, [Total Writes] DESC, [Total Reads] ASC OPTION (RECOMPILE);
-- Look for indexes with high numbers of writes and zero or very low numbers of reads
-- Consider your complete workload, and how long your instance has been running
-- Investigate further before dropping an index!
~~~

# 
### La consulta se basa en tablas/vistas específicas de la base de datos (como sys.indexes) y, por lo tanto, devuelve resultados para el contexto de la base de datos actual.
# 
### Lo primero que quería hacer era envolver la consulta en mi pequeño amigo indocumentado sp_msforeachdb.
# 


~~~sql
EXEC sp_msforeachdb '
/* MODIFIED from Glenn - Possible Bad NC Indexes (writes > reads)  (Query 58) (Bad NC Indexes) */
SELECT ''?'' as DBName,o.Name AS [Table Name], i.name AS [Index Name],
user_updates AS [Total Writes], user_seeks + user_scans + user_lookups AS [Total Reads],
user_updates - (user_seeks + user_scans + user_lookups) AS [Difference],
i.index_id,
i.is_disabled, i.is_hypothetical, i.has_filter, i.fill_factor
FROM sys.dm_db_index_usage_stats AS s WITH (NOLOCK)
INNER JOIN [?].sys.indexes AS i WITH (NOLOCK)
ON s.[object_id] = i.[object_id]
AND i.index_id = s.index_id
INNER JOIN [?].sys.objects as o WITH (nolock)
on i.object_ID=o.Object_ID
WHERE o.type = ''U''
AND s.database_id = DB_ID(''?'')
/* AND user_updates > (user_seeks + user_scans + user_lookups) */
AND i.index_id > 1
AND user_updates - (user_seeks + user_scans + user_lookups) >75000
ORDER BY [Difference] DESC, [Total Writes] DESC, [Total Reads] ASC;
'
~~~

# 

#### La consulta tiene todos los artefactos estándar de sp_msforeachdb, como el marcador de posición del signo de interrogación para el nombre de la base de datos esparcido por todas partes para establecer el contexto adecuado para todas las tablas y vistas específicas de la base de datos (como [?].sys.indexes).
#
#### Aquí fue donde surgió el problema específico de la versión: SQL Server 2008 introdujo el concepto de índices filtrados y, por lo tanto, se agregó una nueva columna (has_filter) a sys.indexes. El resultado es que al ejecutar la consulta anterior (que proviene del script de consulta SQL 2008 de Glenn) se produce un error de columna inexistente.
#
#### Una solución a esto podría haber sido tener una versión modificada de la consulta sin la columna ofensiva, y se alinearía con la forma en que Glenn publica sus consultas, con diferentes scripts para cada versión de SQL Server.
#
#### Para *mi* propósito, quería un solo script que pudiera ejecutar contra cualquier SQL Server 2005+, y la lógica de verificación de versión lo permite.
#
#### Aquí está la versión verificada del script Bad Indexes For All Databases:

#

~~~sql
/*
Bad Indexes DMV For All Databases
http://www.sqlskills.com/blogs/glenn/category/dmv-queries/
Tested on MSSQL 2005/2008/2008R2/2012/2014
*/
SET NOCOUNT ON
DECLARE @SQLVersion char(4)
SET @SQLVersion = left(cast(SERVERPROPERTY('productversion') as varchar),4)
/* PRINT @SQLVersion */
IF LEFT(@SQLVersion,1) NOT IN ('1','9') /* Not 2005+ */
BEGIN
 PRINT 'SQL Server Version Not Supported By This Script'
END
ELSE
BEGIN
 IF @SQLVersion = '9.00' /* 2005 */
 BEGIN
 /* SQL 2005 Version - removes i.has_filter column */
 EXEC sp_msforeachdb '
 /*
 MODIFIED from Glenn - Possible Bad NC Indexes (writes > reads)  (Query 58) (Bad NC Indexes)
 */
 SELECT ''?'' as DBName,o.Name AS [Table Name], i.name AS [Index Name],
 user_updates AS [Total Writes], user_seeks + user_scans + user_lookups AS [Total Reads],
 user_updates - (user_seeks + user_scans + user_lookups) AS [Difference],
 i.index_id,
 i.is_disabled, i.is_hypothetical, i.fill_factor
 FROM sys.dm_db_index_usage_stats AS s WITH (NOLOCK)
 INNER JOIN [?].sys.indexes AS i WITH (NOLOCK)
 ON s.[object_id] = i.[object_id]
 AND i.index_id = s.index_id
 INNER JOIN [?].sys.objects as o WITH (nolock)
 on i.object_ID=o.Object_ID
 WHERE o.type = ''U''
 AND s.database_id = DB_ID(''?'')
 /* AND user_updates > (user_seeks + user_scans + user_lookups) */
 AND i.index_id > 1
 AND user_updates - (user_seeks + user_scans + user_lookups) >75000
 ORDER BY [Difference] DESC, [Total Writes] DESC, [Total Reads] ASC;'
 END
 ELSE
 BEGIN
 EXEC sp_msforeachdb '
 /*
 MODIFIED from Glenn - Possible Bad NC Indexes (writes > reads)  (Query 58) (Bad NC Indexes)
 */
 SELECT ''?'' as DBName,o.Name AS [Table Name], i.name AS [Index Name],
 user_updates AS [Total Writes], user_seeks + user_scans + user_lookups AS [Total Reads],
 user_updates - (user_seeks + user_scans + user_lookups) AS [Difference],
 i.index_id,
 i.is_disabled, i.is_hypothetical, i.has_filter, i.fill_factor
 FROM sys.dm_db_index_usage_stats AS s WITH (NOLOCK)
 INNER JOIN [?].sys.indexes AS i WITH (NOLOCK)
 ON s.[object_id] = i.[object_id]
 AND i.index_id = s.index_id
 INNER JOIN [?].sys.objects as o WITH (nolock)
 on i.object_ID=o.Object_ID
 WHERE o.type = ''U''
 AND s.database_id = DB_ID(''?'')
 /* AND user_updates > (user_seeks + user_scans + user_lookups) */
 AND i.index_id > 1
 AND user_updates - (user_seeks + user_scans + user_lookups) >75000
 ORDER BY [Difference] DESC, [Total Writes] DESC, [Total Reads] ASC;'
 END
END
~~~

# 
#### Esto hizo exactamente lo que quería, devolviendo todos los índices no agrupados con al menos 75 000 escrituras más que lecturas (mi umbral elegido) en todas las bases de datos en la instancia de SQL Server 2005+.

#


# 
# Identificando índices duplicados en SQL Server<a name="indicesduplicados"><a/>
![](https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRn518FNxZ9TzIFTj0hEBKuCkWQUDuq3LpFBQ&usqp=CAU)

#### Un problema común que se puede encontrar en SQL Server son los índices duplicados parcial o totalmente. Los índices son por regla general buenos para mejorar el rendimiento de una base de datos, pero el exceso de índices en una base de datos puede causar que SQL Server gaste mucho tiempo actualizándolos cuando no necesariamente hará uso de ellos.


#### Este es el caso de los índices duplicados, estos nos pueden causar los siguientes problemas:

    Degradación del rendimiento que proviene del overhead 
    causado por el mantenimiento de updates, inserts y deletes

    Incremento en las actividades del log de transacciones
     (llenando los logs, discos y haciendo que Log Shipping falle)

       Incremento en el tamaño de los backups (los índices hacen
     los backups mas grandes, requiriendo mas espacio en disco,
    creando tiempos de mantenimiento mas altos y consumiendo
    más energía para poder realizarlos, además de impactar el
    rendimiento del servidor mientras este se realiza).


## ¿Pero que es un índice duplicado y como lo detecto?

#### Digamos que tenemos la tabla de empleados, la cual posee la siguiente estructura:



#### Y ahora digamos que tenemos dos índices creados para esa tabla:

    - 1. IX_General: Indexa las columnas Codigo_Empleado y Nombre
    - 2. IX_General_Identificacion: Indexa las columnas Codigo_Empleado, Nombre y Numero_Identificacin_Personal

#### En este caso, ambos índices indexan las columnas Codigo_Empleado y Nombre, por lo que se podría decir que uno de ellos solo causa trabajo extra al motor de base de datos. Ahora bien, ¿Como determino cual de los índices borrar?

#### En este punto, se necesita recurrir a la experiencia que se tenga del sistema, en general, se necesita determinar como se realizan las búsquedas en esta tabla. Por ejemplo, si siempre se busca información por Nombre, entonces lo mejor será dejar el índice IX_General, porque es mas pequeño y eficiente, pero si por otro lado, la búsqueda más común fuera por Numero_Identificacion_Personal, lo mejor será entonces quedarse con el índice IX_General_Identificacion, porque este índice incluye la columna que mas se utiliza, volviendo al otro índice obsoleto.

### ***Tenga en cuenta que antes de borrar un índice, debe también verificar que no se estén utilizando sentencias con un index hint que la utilice, de otra forma la eliminación del índice provocará que su sentencia falle.***

## El siguiente procedimiento le ayudará a identificar los índices duplicados en su base de datos:
# 

~~~sql

create procedure [dbo].[usp_duplicateindexes]

@tablename varchar(255)

as

set nocount on

print @tablename

--dump sp_helpindex into temp table

if object_id('tempdb..#helpindex') > 0 drop table #helpindex

create table #helpindex (

index_name varchar (900) not null primary key

, index_description varchar (1000) null

, index_keys varchar (1000) null)

insert #helpindex exec sp_helpindex @tablename

--add [inccols] to temp table & cursor over output, adding included col defs

alter table #helpindex add inccols varchar(1000) null

declare cr cursor for

select si.name, sc.name

from sysobjects so

join sysindexes si on so.id = si.id

join sys.index_columns ic on si.id = ic.object_id and si.indid = ic.index_id

join sys.columns sc on ic.object_id = sc.object_id and ic.column_id = sc.column_id

where so.xtype = 'U'

and so.name = @tablename

and ic.is_included_column = 1

order by si.name, ic.index_column_id

declare @siname varchar(1000), @scname varchar(1000)

open cr

fetch next from cr into @siname, @scname

while @@fetch_status = 0

begin

update #helpindex set inccols = isnull(inccols , '') + @scname + ', ' where index_name = @siname

fetch next from cr into @siname, @scname

end

update #helpindex set inccols = left(inccols, datalength(inccols) - 2) where right(inccols, 2) = ', '

close cr

deallocate cr

--dump duplicates into second temp table & pump results if there are any

if object_id('tempdb..#helpindex2') > 0 drop table #helpindex2

create table #helpindex2 (

index_name varchar (900) not null primary key

, index_description varchar (1000) null

, index_keys varchar (1000) null

, inccols varchar(1000) null

)

insert into #helpindex2

select hi.index_name, hi.index_description, hi.index_keys, hi.inccols

from #helpindex hi

join #helpindex h2 on hi.index_keys=h2.index_keys

and hi.index_description=h2.index_description

and hi.index_name<>h2.index_name

if @@rowcount > 0

select @tablename as "tablename", * from #helpindex2 order by index_name, index_keys, inccols

--cleanup temp objects

if object_id('tempdb..#helpindex2') > 0 drop table #helpindex2

if object_id('tempdb..#helpindex') > 0 drop table #helpindex
~~~

### luego procederemos a Ejecutarlo de la siguiente forma.

~~~sql
exec sp_MSForEachTable 'usp_duplicateindexes''?'''
~~~


# 

# 
# Conceptos básicos del diseño de índices<a name="disenoindices"><a/>
![](https://learn.microsoft.com/es-es/sql/relational-databases/media/sql-server-index-design-guide/hash-index-buckets.png?view=sql-server-ver16)
#### Piense en un libro corriente: al final del libro hay un índice en el que puede localizar rápidamente la información del libro. El índice es una lista ordenada de palabras clave y, junto a cada palabra clave, hay un conjunto de números de página que redirigen a las páginas en las que aparece cada palabra clave. Un índice de SQL Server es parecido: es una lista ordenada de valores y para cada valor hay punteros a las páginas de datos en las que se encuentran estos valores. El propio índice se almacena en páginas, lo que conforma las páginas de índice de SQL Server. En un libro corriente, si el índice abarca varias páginas y tiene que buscar punteros a todas las páginas que contienen, por ejemplo, la palabra "SQL", tendría que pasar las páginas hasta encontrar la página de índice que contiene la palabra clave "SQL". Desde allí, seguiría los punteros a todas las páginas del libro. Esto se podría optimizar aún más si al principio del índice se crea una sola página que contiene una lista alfabética de dónde se puede encontrar cada letra. Por ejemplo: "De la A a la D - página 121", "De la E a la G - página 122", y así sucesivamente. Esta página adicional eliminaría el paso de tener que pasar las páginas por el índice para encontrar la posición de inicio. Esta página no existe en los libros corrientes, pero sí en un índice de SQL Server. Esta página se denomina "página raíz" del índice. La página raíz es la página inicial de la estructura de árbol que se usa en un índice de SQL Server. Siguiendo la analogía del árbol, las páginas finales que contienen punteros a los datos reales se conocen como "páginas hoja" del árbol.
#### Un índice de SQL Server es una estructura en disco o en memoria asociada con una tabla o vista que acelera la recuperación de filas de la tabla o vista. Un índice contiene claves generadas a partir de una o varias columnas de la tabla o la vista. En el caso de los índices en disco, dichas claves están almacenadas en una estructura de árbol (árbol B) que permite que SQL Server busque de forma rápida y eficiente la fila o las filas asociadas a los valores de cada clave.
#### Los índices almacenan los datos organizados de forma lógica como una tabla con filas y columnas, y físicamente almacenados en un formato de datos por fila llamado almacén de filas 1, o bien en un formato de datos por columna llamado almacén de columnas .
##### La selección de los índices apropiados para una base de datos y su carga de trabajo es una compleja operación que busca el equilibrio entre la velocidad de la consulta y el costo de actualización. Los índices estrechos, o con pocas columnas en la clave de índice, necesitan menos espacio en el disco y son menos susceptibles de provocar sobrecargas debido a su mantenimiento. Por otra parte, la ventaja de los índices anchos es que cubren más consultas. Puede que tenga que experimentar con distintos diseños antes de encontrar el índice más eficaz. Es posible agregar, modificar y quitar índices sin que esto afecte al esquema de la base de datos o al diseño de la aplicación. Por lo tanto, no debe dudar en experimentar con índices diferentes.
#### El optimizador de consultas de SQL Server elige de forma confiable el índice más eficaz en la mayoría de los casos. La estrategia general de diseño de índices debe proporcionar una buena selección de índices al optimizador de consultas y confiar en que tomará la decisión correcta. Así se reduce el tiempo de análisis y se obtiene un buen rendimiento en diversas situaciones. Para saber qué índices utiliza el optimizador de consultas para determinada consulta, en SQL Server Management Studio, en el menú Consulta , seleccione Incluir plan de ejecución real.
#### No equipare siempre la utilización de índices con un buen rendimiento ni el buen rendimiento al uso eficaz del índice. Si la utilización de un índice contribuyera siempre a producir el mejor rendimiento, el trabajo del optimizador de consultas sería muy sencillo. En realidad, una elección incorrecta de índice puede provocar un rendimiento bajo. Por tanto, la tarea del optimizador de consultas consiste en seleccionar un índice o una combinación de índices solo si mejora el rendimiento, y evitar la recuperación indizada cuando afecte al mismo.
 ####  Los almacenes de filas han sido la forma tradicional de almacenar los datos de una tabla relacional. En SQL Server, "almacén de filas" hace referencia a la tabla en la que el formato de almacenamiento de datos subyacente es un montón, un árbol B (índice agrupado) o una tabla optimizada para memoria.

# Tareas del diseño de índices<a name="tareadisind"></a>
#
 ### 1- Las siguientes tareas componen la estrategia recomendada para el diseño de índices:
### Comprender las características de la propia base de datos.
### Por ejemplo, si es una base de datos de procesamiento de transacciones en línea (OLTP) con modificaciones de datos frecuentes que deben tener un alto rendimiento. A partir de SQL Server 2014 (12.x), las tablas y los índices optimizados para memoria son especialmente adecuados en este escenario, ya que proporcionan un diseño sin bloqueos temporales. Para obtener más información, en esta guía podrá ver Índices de tablas optimizadas para memoria, Nonclustered Index for Memory-Optimized Tables Design Guidelines (Guía de diseño de índices no agrupados para tablas optimizadas para memoria) y Hash Index for Memory-Optimized Tables Design Guidelines (Guía de diseño de índices de hash para tablas optimizadas para memoria).
#
### O bien, el ejemplo de una base de datos de sistema de ayuda a la toma de decisiones (DSS) o almacenamiento de datos (OLAP) que debe procesar con rapidez conjuntos de datos muy grandes. A partir de SQL Server 2012 (11.x), los índices de almacén de columnas son especialmente adecuados para los conjuntos de datos de almacenamiento de datos comunes. Los índices de almacén de columnas pueden transformar la experiencia de almacenamiento de datos de los usuarios, ya que permite un rendimiento más rápido en las consultas habituales de almacenamiento de datos, como el filtrado, la agregación, la agrupación y la combinación en estrella de consultas. Para obtener más información, vea Introducción a los índices de almacén de columnas o Directrices para diseñar índices de almacén de columnas en esta guía.
### 2 - Comprender las características de las consultas utilizadas con frecuencia. Por ejemplo, saber que una consulta utilizada con frecuencia une dos o más tablas facilitará la determinación del mejor tipo de índices que se puede utilizar.
### 3-  Comprender las características de las columnas utilizadas en las consultas. Por ejemplo, un índice es idóneo para columnas que tienen un tipo de datos entero y además son columnas con valores NULL o no NULL. En el caso de columnas que tengan subconjuntos de datos bien definidos, puede usar un índice filtrado en SQL Server 2008 y en versiones posteriores. Para obtener más información, vea Directrices generales para diseñar índices filtrados en esta guía.
### 4 - Determinar qué opciones de índice podrían mejorar el rendimiento al crear o mantener el índice. Por ejemplo, la creación de un índice agrupado en una tabla grande se beneficiaría de la opción de índice ONLINE. La opción ONLINE permite que la actividad simultánea en los datos subyacentes continúe mientras el índice se crea o regenera. Para obtener más información, consulte Establecer opciones de índice.
### 5 -Determinar la ubicación de almacenamiento óptima para el índice. Un índice no clúster se puede almacenar en el mismo grupo de archivos que la tabla subyacente o en un grupo distinto. La ubicación de almacenamiento de índices puede mejorar el rendimiento de las consultas aumentando el rendimiento de las operaciones de E/S en disco. Por ejemplo, el almacenamiento de un índice no clúster en un grupo de archivos que se encuentra en un disco distinto que el del grupo de archivos de la tabla puede mejorar el rendimiento, ya que se pueden leer varios discos al mismo tiempo.
### O bien, los índices clúster y no clúster pueden utilizar un esquema de particiones en varios grupos de archivos. Las particiones facilitan la administración de índices y tablas grandes al permitir el acceso y la administración de subconjuntos de datos rápidamente y con eficacia, mientras se mantiene la integridad de la colección global. Para obtener más información, vea Partitioned Tables and Indexes. Al considerar la posibilidad de utilizar particiones, determine si el índice debe alinearse; es decir, si las particiones se crean esencialmente del mismo modo que la tabla o de forma independiente.

# Directrices generales para diseñar índices
### Los administradores de bases de datos más experimentados pueden diseñar un buen conjunto de índices, pero esta tarea es muy compleja, consume mucho tiempo y está sujeta a errores, incluso con cargas de trabajo y bases de datos con un grado de complejidad no excesivo. La comprensión de las características de la base de datos, las consultas y las columnas de datos facilita el diseño de los índices.

# 

# Consideraciones acerca de la base de datos<a name="consibasedatos"></a>
### Cuando diseñe un índice, tenga en cuenta las siguientes directrices acerca de la base de datos:
 - Si se usa un gran número de índices en una tabla, el rendimiento de las instrucciones INSERT, UPDATE, DELETE y MERGE se verá afectado, ya que todos los índices deben ajustarse adecuadamente a medida que cambian los datos de la tabla. Por ejemplo, si una columna se usa en varios índices y ejecuta una instrucción UPDATE que modifica datos de esa columna, se deben actualizar todos los índices que contengan esa columna, así como la columna de la tabla base subyacente (índice de montón o agrupado).
      - Evite crear demasiados índices en tablas que se actualizan con mucha frecuencia y mantenga los índices estrechos, es decir, defínalos con el menor número de columnas posible.
      - Utilice un número mayor de índices para mejorar el rendimiento de consultas en tablas con pocas necesidades de actualización, pero con grandes volúmenes de datos. Un gran número de índices contribuye a mejorar el rendimiento de las consultas que no modifican datos, como las instrucciones SELECT, ya que el optimizador de consultas dispone de más índices entre los que elegir para determinar el método de acceso más rápido.
- La indización de tablas pequeñas puede no ser una solución óptima, porque puede provocar que el optimizador de consultas tarde más tiempo en realizar la búsqueda de los datos a través del índice que en realizar un simple recorrido de la tabla. De este modo, es posible que los índices de tablas pequeñas no se utilicen nunca; sin embargo, sigue siendo necesario su mantenimiento a medida que cambian los datos de la tabla.
 - Los índices en vistas pueden mejorar de forma significativa el rendimiento si la vista contiene agregaciones, combinaciones de tabla o una mezcla de agregaciones y combinaciones. No es necesario hacer referencia de forma explícita a la vista en la consulta para que el optimizador de consultas la utilice.
 - Utilice el Asistente para la optimización de motor de base de datos para analizar las bases de datos y crear recomendaciones de índices. Para obtener más información, vea [Database Engine Tuning Advisor](https://docs.microsoft.com/es-es/sql/relational-databases/performance/database-engine-tuning-advisor?view=sql-server-ver15)

# 

## Eliminar todos los indices que no fueron creados ONLNE =ON,y Crearlos nuevamente de forma ONLINE=ON<a name="6.8"></a>

#### Para lograr esto, primero necesitas obtener una lista de todos los índices que no están creados con la opción ONLINE = ON, eliminarlos y luego volver a crearlos con la opción ONLINE = ON. Puedes hacerlo a través de un script SQL en SQL Server. Asegúrate de tomar precauciones antes de ejecutar estos comandos en un entorno de producción, ya que eliminar y recrear índices puede causar bloqueos temporales en las tablas afectadas. Aquí tienes un ejemplo de cómo podrías hacerlo:

~~~sql
-- Declarar una variable temporal para almacenar los nombres de las tablas
DECLARE @TableName NVARCHAR(128);

-- Declarar un cursor para recorrer todas las tablas
DECLARE TableCursor CURSOR FOR
SELECT name
FROM sys.tables;

-- Variables para almacenar el nombre del índice y el nombre de la tabla
DECLARE @IndexName NVARCHAR(128);
DECLARE @IndexTableName NVARCHAR(128);

-- Variable para almacenar el comando SQL dinámico
DECLARE @SQLCommand NVARCHAR(MAX);

-- Abrir el cursor
OPEN TableCursor;

-- Recorrer las tablas
FETCH NEXT FROM TableCursor INTO @TableName;
WHILE @@FETCH_STATUS = 0
BEGIN
    -- Cursor para recorrer los índices de la tabla
    DECLARE IndexCursor CURSOR FOR
    SELECT name, object_name(object_id) as TableName
    FROM sys.indexes
    WHERE object_id = OBJECT_ID(@TableName) AND is_disabled = 0 AND type_desc <> 'HEAP' AND type_desc <> 'XML';

    -- Recorrer los índices
    FETCH NEXT FROM IndexCursor INTO @IndexName, @IndexTableName;
    WHILE @@FETCH_STATUS = 0
    BEGIN
        -- Generar y ejecutar el comando SQL para eliminar el índice
        SET @SQLCommand = 'DROP INDEX ' + QUOTENAME(@IndexTableName) + '.' + QUOTENAME(@IndexName);
        EXEC sp_executesql @SQLCommand;

        -- Generar y ejecutar el comando SQL para recrear el índice con ONLINE = ON
        SET @SQLCommand = 'CREATE INDEX ' + QUOTENAME(@IndexName) + ' ON ' + QUOTENAME(@IndexTableName) + ' (YourColumns) WITH (ONLINE = ON)';
        EXEC sp_executesql @SQLCommand;

        FETCH NEXT FROM IndexCursor INTO @IndexName, @IndexTableName;
    END

    -- Cerrar y desasignar el cursor de índices
    CLOSE IndexCursor;
    DEALLOCATE IndexCursor;

    FETCH NEXT FROM TableCursor INTO @TableName;
END

-- Cerrar y desasignar el cursor de tablas
CLOSE TableCursor;
DEALLOCATE TableCursor;

~~~
# 
#### En este código, se utiliza un cursor para recorrer todas las tablas de la base de datos y otro cursor para recorrer los índices de cada tabla. Para cada índice, se ejecuta una instrucción DROP INDEX para eliminarlo y luego se ejecuta una instrucción CREATE INDEX para recrearlo con la opción ONLINE = ON.

#### Asegúrate de ajustar la parte (YourColumns) con las columnas adecuadas de tus índices y de realizar pruebas en un entorno de desarrollo o copia de seguridad antes de aplicar este script en producción.





# 
## para mas informacion sobre la creacion y mantenimiento de indices en Sql Server ver las paginas [Ver Documentacion](https://docs.microsoft.com/es-es/sql/relational-databases/sql-server-index-design-guide?view=sql-server-ver15#:~:text=Un%20%C3%ADndice%20de%20SQL%20Server%20es%20una%20estructura%20en%20disco,de%20la%20tabla%20o%20vista.&text=Un%20%C3%ADndice%20contiene%20claves%20generadas,la%20tabla%20o%20la%20vista.)

# 

## Listado de los indices que tiene una Base de Datos<a name="6.9"></a>
####  Por supuesto, puedes utilizar la siguiente consulta para obtener una lista de los índices presentes en una base de datos específica en SQL Server:

~~~sql
USE TuBaseDeDatos;

SELECT 
    OBJECT_NAME(object_id) AS NombreObjeto,
    name AS NombreIndice,
    type_desc AS Tipo,
    CASE WHEN is_primary_key = 1 THEN 'Sí' ELSE 'No' END AS EsClavePrimaria,
    CASE WHEN is_unique = 1 THEN 'Sí' ELSE 'No' END AS EsUnico
FROM 
    sys.indexes
WHERE 
    type IN (1,2) -- Índices clustered y no agrupados
ORDER BY 
    OBJECT_NAME(object_id), name;
~~~

#### Asegúrate de reemplazar "TuBaseDeDatos" con el nombre de la base de datos que estás utilizando. Esta consulta mostrará los siguientes detalles para cada índice:

- Nombre del objeto (tabla o vista) al que pertenece el índice.
- Nombre del índice.
- Tipo de índice (clustered o nonclustered).
- Si el índice es una clave primaria o no.
- Si el índice es único o no.

#### Esta consulta filtra los tipos de índices para mostrar solo los índices clustered y nonclustered. Si necesitas información sobre otros tipos de índices, puedes ajustar la consulta según tus necesidades.

# 



# Consulta para identificar el Filegroup de los índices en SQL Server<a name="3.3"></a>

**Propiedad de:** JOSE ALEJANDRO JIMENEZ ROSA  
**Fecha:** mayo 27, 2025  

---

## 📊 Resumen

Este documento describe una consulta en SQL Server que permite obtener información sobre el *filegroup* en el que están almacenados los índices dentro de una base de datos. Es útil para el análisis de rendimiento y la administración del almacenamiento.

---

## 🧠 Query SQL

```sql
SELECT 
    i.name AS IndexName,
    t.name AS TableName,
    fg.name AS FileGroupName
FROM sys.indexes i
JOIN sys.tables t ON i.object_id = t.object_id
JOIN sys.data_spaces fg ON i.data_space_id = fg.data_space_id
WHERE i.type > 0 -- Filtra solo los índices (excluye heaps)
ORDER BY fg.name, t.name, i.name;
```

---

## 🔍 Explicación del Query

El script se basa en las siguientes vistas del sistema:

- `sys.indexes`: Contiene información sobre los índices.
- `sys.tables`: Relaciona los índices con sus respectivas tablas.
- `sys.data_spaces`: Permite identificar en qué filegroup están ubicados los índices.

El filtro `i.type > 0` excluye *heaps* y se asegura de traer solo índices estructurados.

---

## 📌 Casos de Uso

Este query es útil en escenarios como:

- **Optimización de rendimiento:** Permite evaluar la distribución de índices en distintos filegroups.
- **Administración del almacenamiento:** Identificar y modificar la ubicación de índices según necesidades de espacio y acceso.

---

## ✅ Recomendaciones

- Es recomendable ejecutar este query en bases de datos grandes para evaluar si los índices están correctamente distribuidos.
- Se puede extender agregando más columnas para obtener detalles adicionales, como el tipo de índice (`i.type_desc`).

---

## 📚 Referencias

- [Documentación oficial de SQL Server](https://learn.microsoft.com/sql)
- Temas relacionados: Administración de filegroups, rendimiento de índices, diseño de almacenamiento.

---



#

# Evaluación de Índices en SQL Server<a name="3113"></a>

## Descripción General
Este script tiene como objetivo evaluar la efectividad de los últimos índices creados en una base de datos de SQL Server. A través del análisis de los índices más recientes, se busca determinar si estos han tenido un impacto positivo en el rendimiento de la base de datos, y cuantificar el impacto en términos de uso de CPU, memoria y almacenamiento.

El código se divide en varias partes utilizando Common Table Expressions (CTEs) que permiten la evaluación de los índices desde distintas perspectivas: la creación reciente, el uso de los índices y el impacto en términos de memoria.

## Componentes del Código

### 1. **RecentIndexes**
En esta sección, se seleccionan los índices creados recientemente en la base de datos, filtrando únicamente tablas de usuario (`o.type = 'U'`). Se incluyen detalles relevantes como el nombre del índice, la tabla a la que pertenece, el tipo de índice, y si es único o una clave primaria. Los índices se ordenan de manera descendente por el identificador del índice (`index_id`) para listar los más recientes primero.

### 2. **IndexEffectiveness**
Esta sección permite evaluar la efectividad de cada índice considerando su uso y actualizaciones. Los datos se obtienen de la vista de sistema `sys.dm_db_index_usage_stats`, que contiene información sobre búsquedas (`user_seeks`), exploraciones (`user_scans`), y actualizaciones (`user_updates`) realizadas sobre los índices. También se proporciona un cálculo del `effectiveness_ratio`, que muestra la relación entre la cantidad de lecturas y las actualizaciones realizadas sobre el índice.

### 3. **IndexImpact**
Esta parte del código proporciona información sobre el impacto del índice en términos de uso de memoria y almacenamiento. Se calculan dos métricas principales: el uso de memoria (`memory_usage_mb`) y el almacenamiento total utilizado (`total_storage_mb`). Los valores se obtienen de la vista `sys.dm_db_partition_stats` y se expresan en megabytes (MB).

### 4. **Consulta Final**
La consulta final combina los resultados de las tres CTEs para proporcionar una visión integral de los índices recientes, mostrando:
- **Nombre del Índice** y **Tabla**.
- **Tipo de Índice**, si es único (**is_unique**) y si es clave primaria (**is_primary_key**).
- **Uso del Índice**: la cantidad de búsquedas, exploraciones, y actualizaciones.
- **Impacto en Rendimiento**: el uso de memoria y almacenamiento.

Los resultados se ordenan de manera descendente para mostrar los índices más recientes primero.

## Código Completo
```sql
WITH RecentIndexes AS
(
    SELECT TOP 100 PERCENT
        i.name AS index_name,
        i.object_id,
        i.index_id,
        i.type_desc,
        i.is_unique,
        i.is_primary_key,
        i.fill_factor,
        OBJECT_NAME(i.object_id) AS table_name
    FROM sys.indexes i
    JOIN sys.objects o ON i.object_id = o.object_id
    WHERE o.type = 'U' -- Only user tables
    ORDER BY i.index_id DESC
),
IndexEffectiveness AS
(
    SELECT
        i.name AS index_name,
        i.object_id,
        s.user_seeks + s.user_scans + s.user_lookups AS usage_count,
        s.user_updates AS update_count,
        s.last_user_seek,
        s.last_user_scan,
        s.last_user_lookup,
        s.last_user_update,
        CASE
            WHEN s.user_updates = 0 THEN 'N/A'
            ELSE CAST((s.user_seeks + s.user_scans + s.user_lookups) / CAST(s.user_updates AS FLOAT) AS VARCHAR(50))
        END AS effectiveness_ratio
    FROM sys.dm_db_index_usage_stats s
    JOIN sys.indexes i ON s.object_id = i.object_id AND s.index_id = i.index_id
    WHERE database_id = DB_ID()
),
IndexImpact AS
(
    SELECT
        i.index_id,
        i.name AS index_name,
        i.object_id,
        ps.used_page_count * 8.0 / 1024 AS memory_usage_mb, -- Memory usage in MB
        (ps.in_row_data_page_count + ps.lob_used_page_count + ps.row_overflow_used_page_count) * 8.0 / 1024 AS total_storage_mb -- Storage usage in MB
    FROM sys.dm_db_partition_stats ps
    JOIN sys.indexes i ON ps.object_id = i.object_id AND ps.index_id = i.index_id
)
SELECT
    r.index_name,
    r.table_name,
    r.type_desc,
    r.is_unique,
    r.is_primary_key,
    r.fill_factor,
    ie.usage_count,
    ie.update_count,
    ie.last_user_seek,
    ie.last_user_scan,
    ie.last_user_lookup,
    ie.last_user_update,
    ie.effectiveness_ratio,
    ii.memory_usage_mb,
    ii.total_storage_mb
FROM RecentIndexes r
LEFT JOIN IndexEffectiveness ie ON r.index_name = ie.index_name AND r.object_id = ie.object_id
LEFT JOIN IndexImpact ii ON r.index_name = ii.index_name AND r.object_id = ii.object_id
ORDER BY r.index_id DESC;
```

## Uso del Script
- **Evaluación de Impacto**: Ejecutar este script permitirá evaluar si los índices recién creados están siendo utilizados de forma efectiva y si están mejorando el rendimiento de la base de datos.
- **Análisis de Recursos**: Los resultados obtenidos también mostrarán el uso de memoria y almacenamiento, ayudando a identificar si algún índice está consumiendo demasiados recursos y podría necesitar ajuste o eliminación.

## Recomendaciones
- Ejecuta el script en un entorno de pruebas antes de usarlo en producción.
- Monitorea los índices que tienen bajo `effectiveness_ratio` o un alto uso de memoria para optimizar la base de datos.

## Consideraciones Finales
La efectividad de los índices depende de cómo las consultas se ejecutan contra la base de datos. Un índice que no se utiliza adecuadamente puede afectar el rendimiento de la base de datos, ocupando espacio y ralentizando las operaciones de inserción o actualización. Este script es útil para detectar esos índices y tomar acciones correctivas. Puedes ajustar la lógica según las necesidades específicas de tu entorno.







# 

# Documentación sobre Consultas de Índices en SQL Server

## Índice

- [Introducción](#introducci%C3%B3n)
- [Identificación de Índices Innecesarios](#identificaci%C3%B3n-de-%C3%ADndices-innecesarios)
- [Detalles de los Índices en las Tablas](#detalles-de-los-%C3%ADndices-en-las-tablas)
- [Comparación y Agrupación de Índices](#comparaci%C3%B3n-y-agrupaci%C3%B3n-de-%C3%ADndices)
- [Conclusión](#conclusi%C3%B3n)

---

## Introducción

Esta documentación describe varios scripts en SQL Server para el análisis de índices. Estos scripts ayudan a identificar índices innecesarios, obtener detalles de los índices en las tablas y comparar índices para mejorar la eficiencia del sistema.

---

## Identificación de Índices Innecesarios

### Objetivo

Este script ayuda a identificar índices que no están siendo utilizados (sin `seeks`, `scans` o `lookups`), pero que siguen recibiendo actualizaciones (`updates`). Esto puede ayudar a determinar si es necesario eliminarlos para mejorar el rendimiento de la base de datos.

### Script

```sql
SELECT
    OBJECT_NAME(I.[object_id]) AS [Table Name],
    I.name AS [Index Name],
    I.type_desc AS [Index Type],
    S.user_seeks AS [Seeks],
    S.user_scans AS [Scans],
    S.user_lookups AS [Lookups],
    S.user_updates AS [Updates],
    P.rows AS [Total Rows],
    'DROP INDEX ' + I.name + ' ON ' + OBJECT_NAME(I.[object_id]) AS [Drop Script]
FROM
    sys.indexes I
LEFT JOIN
    sys.dm_db_index_usage_stats S
    ON I.[object_id] = S.[object_id] AND I.index_id = S.index_id
JOIN
    sys.partitions P ON I.[object_id] = P.[object_id] AND I.index_id = P.index_id
WHERE
    OBJECTPROPERTY(I.[object_id], 'IsUserTable') = 1
    AND I.type_desc <> 'HEAP'
    AND I.is_primary_key = 0
    AND I.is_unique = 0
    AND (S.user_seeks IS NULL OR S.user_seeks = 0)
    AND (S.user_scans IS NULL OR S.user_scans = 0)
ORDER BY
    S.user_updates DESC, [Table Name], [Index Name];
```

### Uso
- Identificar índices sin actividad de lectura.
- Generar un script de eliminación (`DROP INDEX`).
- Mejorar el rendimiento eliminando índices innecesarios.

---

## Detalles de los Índices en las Tablas

### Objetivo

Este script extrae información sobre los índices existentes en las tablas, mostrando los nombres de las columnas, el tipo de índice y si se trata de columnas incluidas.

### Script

```sql
SELECT
    t.name AS TableName,
    i.name AS IndexName,
    i.type_desc AS IndexType,
    ic.key_ordinal AS KeyOrdinal,
    c.name AS ColumnName,
    ic.is_included_column AS IsIncludedColumn
FROM
    sys.tables t
JOIN
    sys.indexes i ON t.object_id = i.object_id
JOIN
    sys.index_columns ic ON i.index_id = ic.index_id AND t.object_id = ic.object_id
JOIN
    sys.columns c ON t.object_id = c.object_id AND c.column_id = ic.column_id
WHERE
    t.is_ms_shipped = 0
ORDER BY
    t.name, i.name, ic.key_ordinal;
```

### Uso
- Obtener información detallada de los índices en una base de datos.
- Identificar columnas clave e incluidas en los índices.
- Optimizar la indexación según las necesidades de consulta.

---

## Comparación y Agrupación de Índices

### Objetivo

Este conjunto de consultas permite identificar índices redundantes o similares dentro de una tabla. Ayuda a comparar índices basados en las columnas que contienen y su tipo.

### Script

```sql
WITH BaseNumbers AS (
  SELECT 1 AS ColId
  UNION ALL
  SELECT ColId+1
  FROM BaseNumbers
)
, IndexColumns AS (
  SELECT Sch.name AS SchemaName,
    objetos.name AS TableName,
    indices.name AS IndexName,
    indices.type_desc AS IndexType,
    indices.index_id,
    Idc.key_ordinal,
    Col.name AS ColumnName
  FROM sys.indexes AS indices
  INNER JOIN sys.objects AS objetos
    ON indices.object_id = objetos.object_id
  INNER JOIN sys.schemas AS SCH
    ON objetos.schema_id = SCH.schema_id
  JOIN sys.index_columns AS Idc
    ON indices.index_id = Idc.index_id
      AND indices.object_id = Idc.object_id
  INNER JOIN sys.columns AS Col
    ON Col.column_id = Idc.column_id
    AND Col.object_id = Idc.object_id
  WHERE indices.index_id > 0
    AND objetos.is_ms_shipped=0
    AND objetos.type in ('U ')
    AND indices.type IN (1,2,7)
    AND Idc.is_included_column=0
)
SELECT * FROM IndexColumns;
```

### Uso
- Comparar índices para identificar redundancias.
- Analizar índices con columnas compartidas.
- Detectar oportunidades para eliminar o consolidar índices.

---

## Conclusión


# Defragmentación, al rescate<a name="desfragmentacionalrescate"></a>
![](https://greyphillips.com/Guides/assets/img/Database_Maintenance.png)




#### Para evitar el deterioro del rendimiento en nuestro servidor, deberemos mantener nuestros índices en un estado de fragmentación óptimo. Lo podremos lograr sencillamente siguiendo estos pasos.

#### Primer paso: detectar fragmentación en los índices de tu base de datos. Para ello, nos basaremos en la vista de sistema sys.dm_db_index_physical_stats, que encapsularemos en la siguiente query:
# 


~~~sql
SELECT DB_NAME(database_id) AS DatabaseName, database_id, 
OBJECT_NAME(ips.object_id) AS TableName, ips.object_id,

i.name AS IndexName, i.index_id, p.rows,

ips.partition_number, index_type_desc, alloc_unit_type_desc, 
index_depth, index_level,
avg_fragmentation_in_percent, fragment_count, avg_fragment_size_in_pages, page_count,
avg_page_space_used_in_percent, record_count, ghost_record_count, version_ghost_record_count, min_record_size_in_bytes,
max_record_size_in_bytes, avg_record_size_in_bytes, forwarded_record_count
FROM sys.dm_db_index_physical_stats (DB_ID(), NULL, NULL , NULL, 'LIMITED') ips
INNER JOIN sys.indexes i ON i.object_id = ips.object_id AND i.index_id = ips.index_id
INNER JOIN sys.partitions p ON p.object_id = i.object_id AND p.index_id = i.index_id
WHERE avg_fragmentation_in_percent > 10.0 AND ips.index_id > 0 AND page_count > 1000
ORDER BY avg_fragmentation_in_percent DESC
~~~
# 


# Servidores Standar Edition Sql server ,no soportan (ONLINE=ON)

#### Segundo paso: ejecutar un script para defragmentar los índices con problemas. El script determina si hay que hacer un Reorganize o un Rebuild para cada índice:
# 

#### Esta es una fragmentacion estandar , para servidores de sql server Standar.  en la misma se realizaran las defragmentaion de los indices de la db seleccionada

~~~sql
-- Ensure a USE  statement has been executed first.
SET NOCOUNT ON;
DECLARE @objectid int;
DECLARE @indexid int;
DECLARE @partitioncount bigint;
DECLARE @schemaname nvarchar(130); 
DECLARE @objectname nvarchar(130); 
DECLARE @indexname nvarchar(130); 
DECLARE @partitionnum bigint;
DECLARE @partitions bigint;
DECLARE @frag float;
DECLARE @command nvarchar(4000); 
-- Conditionally select tables and indexes from the sys.dm_db_index_physical_stats function 
-- and convert object and index IDs to names.
SELECT
    object_id AS objectid,
    index_id AS indexid,
    partition_number AS partitionnum,
    avg_fragmentation_in_percent AS frag
INTO #work_to_do
FROM sys.dm_db_index_physical_stats (DB_ID(), NULL, NULL , NULL, 
'LIMITED')
WHERE avg_fragmentation_in_percent > 10.0 AND index_id > 0 AND 
page_count > 1000;

-- Declare the cursor for the list of partitions to be processed.
DECLARE partitions CURSOR FOR SELECT * FROM #work_to_do;

-- Open the cursor.
OPEN partitions;

-- Loop through the partitions.
WHILE (1=1)
    BEGIN;
        FETCH NEXT
           FROM partitions
           INTO @objectid, @indexid, @partitionnum, @frag;
        IF @@FETCH_STATUS < 0 BREAK;
        SELECT @objectname = QUOTENAME(o.name), @schemaname = QUOTENAME(s.name)
        FROM sys.objects AS o
        JOIN sys.schemas as s ON s.schema_id = o.schema_id
        WHERE o.object_id = @objectid;
        SELECT @indexname = QUOTENAME(name)
        FROM sys.indexes
        WHERE  object_id = @objectid AND index_id = @indexid;
        SELECT @partitioncount = count (*)
        FROM sys.partitions
        WHERE object_id = @objectid AND index_id = @indexid;

-- 30 is an arbitrary decision point at which to switch between reorganizing and rebuilding.
     IF @frag < 30.0
       SET @command = N'ALTER INDEX ' + @indexname + N' ON ' + 
       @schemaname + N'.' + @objectname + N' REORGANIZE';
     IF @frag >= 30.0
         SET @command = N'ALTER INDEX ' + @indexname + N' ON ' + 
         @schemaname + N'.' + @objectname + N' REBUILD';
     IF @partitioncount > 1
            SET @command = @command + N' PARTITION=' + CAST
            (@partitionnum AS nvarchar(10));
        EXEC (@command);
        PRINT N'Executed: ' + @command;
    END;

-- Close and deallocate the cursor.
CLOSE partitions;
DEALLOCATE partitions;

-- Drop the temporary table.
DROP TABLE #work_to_do;
GO
~~~


# Servidores Interprise Edition Sql server 

#### Segundo paso: ejecutar un script para defragmentar los índices con problemas. El script determina si hay que hacer un Reorganize o un Rebuild para cada índice:

#### En esta versión modificada del script, se ha agregado la opción WITH (ONLINE = ON) en las instrucciones ALTER INDEX para que las operaciones se realicen en línea, lo que minimizará el bloqueo de las tablas y permitirá que las consultas y las inserciones continúen sin interrupciones. 

####  También se ha incluido una condición adicional para decidir si se realiza una reconstrucción en línea basada en el tamaño de la tabla y el nivel de fragmentación. Las reorganizaciones se seguirán realizando en línea. 

#### ***Debemos tener en cuenta que la disponibilidad de la opción ONLINE puede depender de la edición de SQL Server que estemos utilizando.***
#####   ***Este query solo funciona con Sql Server Interprise Edition.***
# 


~~~sql
-- Ensure a USE statement has been executed first.
-- Asegurarse de que se haya ejecutado una instrucción USE primero.
SET NOCOUNT ON;
DECLARE @objectid INT;
DECLARE @indexid INT;
DECLARE @partitioncount BIGINT;
DECLARE @schemaname NVARCHAR(130);
DECLARE @objectname NVARCHAR(130);
DECLARE @indexname NVARCHAR(130);
DECLARE @partitionnum BIGINT;
DECLARE @partitions BIGINT;
DECLARE @frag FLOAT;
DECLARE @command NVARCHAR(4000);

-- Condición para seleccionar tablas e índices de la función sys.dm_db_index_physical_stats
-- y convertir los IDs de objetos e índices en nombres.
SELECT
    object_id AS objectid,
    index_id AS indexid,
    partition_number AS partitionnum,
    avg_fragmentation_in_percent AS frag
INTO #work_to_do
FROM sys.dm_db_index_physical_stats (DB_ID(), NULL, NULL, NULL, 'LIMITED')
WHERE avg_fragmentation_in_percent > 10.0 AND index_id > 0 AND
page_count > 1000;

-- Declarar el cursor para la lista de particiones a procesar.
DECLARE partitions CURSOR FOR SELECT * FROM #work_to_do;

-- Abrir el cursor.
OPEN partitions;

-- Loop a través de las particiones.
WHILE (1=1)
BEGIN
    FETCH NEXT
    FROM partitions
    INTO @objectid, @indexid, @partitionnum, @frag;
    IF @@FETCH_STATUS < 0 BREAK;

    SELECT @objectname = QUOTENAME(o.name), @schemaname = QUOTENAME(s.name)
    FROM sys.objects AS o
    JOIN sys.schemas AS s ON s.schema_id = o.schema_id
    WHERE o.object_id = @objectid;

    SELECT @indexname = QUOTENAME(name)
    FROM sys.indexes
    WHERE  object_id = @objectid AND index_id = @indexid;

    SELECT @partitioncount = COUNT(*)
    FROM sys.partitions
    WHERE object_id = @objectid AND index_id = @indexid;

    -- 30 es un punto de decisión arbitrario para cambiar entre reorganización y reconstrucción.
    IF @frag < 30.0
        SET @command = N'ALTER INDEX ' + @indexname + N' ON ' + 
        @schemaname + N'.' + @objectname + N' REORGANIZE';
    ELSE IF @frag >= 30.0 AND @partitioncount <= 1
        SET @command = N'ALTER INDEX ' + @indexname + N' ON ' + 
        @schemaname + N'.' + @objectname + N' REBUILD WITH (ONLINE = ON)';
    ELSE IF @frag >= 30.0 AND @partitioncount > 1
        SET @command = N'ALTER INDEX ' + @indexname + N' ON ' + 
        @schemaname + N'.' + @objectname + N' REBUILD PARTITION=' + 
        CAST(@partitionnum AS NVARCHAR(10)) + N' WITH (ONLINE = ON)';

    BEGIN TRY
        EXEC (@command);
        PRINT N'Executed: ' + @command;
    END TRY
    BEGIN CATCH
        PRINT N'Error executing: ' + @command;
        -- Puedes registrar el error o realizar cualquier otra acción aquí si es necesario.
    END CATCH
END;

-- Cerrar y liberar el cursor.
CLOSE partitions;
DEALLOCATE partitions;

-- Eliminar la tabla temporal.
DROP TABLE #work_to_do;
GO

~~~
# 


# Servidores Interprise Edition Sql server , OPTIMIZADO, Puede ejecutarse de forma constante, sin interferir con las operaciones del servidor.   Especial para bases de datos Muy Grandes y que necesitan ser defragmentadas.

## defragmentar con intervalos de 10 indices y excluye los que ya fueron leidos para mayor eficiencia


~~~sql
-- Asegurarse de que se haya ejecutado una instrucción USE primero.
SET NOCOUNT ON;
DECLARE @objectid INT;
DECLARE @indexid INT;
DECLARE @partitioncount BIGINT;
DECLARE @schemaname NVARCHAR(130);
DECLARE @objectname NVARCHAR(130);
DECLARE @indexname NVARCHAR(130);
DECLARE @partitionnum BIGINT;
DECLARE @partitions BIGINT;
DECLARE @frag FLOAT;
DECLARE @command NVARCHAR(4000);

-- Condición para seleccionar tablas e índices de la función sys.dm_db_index_physical_stats

-- y convertir los IDs de objetos e índices en nombres.


declare @datos table

(

id int

,indexs int

,partic int

,frag float

)


-- SI AL TABLA TEMPORAL EXISTE ELIMINALA.
    BEGIN TRY
        DROP TABLE #work_to_do;
    END TRY
    BEGIN CATCH
         PRINT N'error executing';
    END CATCH


 

while exists (
SELECT  top 10
    object_id AS objectid,
    index_id AS indexid,
    partition_number AS partitionnum,
    avg_fragmentation_in_percent AS frag
--INTO #work_to_do
FROM sys.dm_db_index_physical_stats (DB_ID(), NULL, NULL, NULL, 'LIMITED')
WHERE avg_fragmentation_in_percent > 10.0 AND index_id > 0 AND
page_count > 1000
and  object_id  not in
    (
        select id from @datos
    )
)
begin
SELECT top 10
    object_id AS objectid,
    index_id AS indexid,
    partition_number AS partitionnum,
    avg_fragmentation_in_percent AS frag
INTO #work_to_do
FROM sys.dm_db_index_physical_stats (DB_ID(), NULL, NULL, NULL, 'LIMITED')
WHERE avg_fragmentation_in_percent > 10.0 AND index_id > 0 AND
page_count > 1000
and  object_id  not in
    (
    select id from @datos
    )
;

-- Declarar el cursor para la lista de particiones a procesar.
DECLARE partitions CURSOR FOR SELECT * FROM #work_to_do;
-- Abrir el cursor.
OPEN partitions;

-- Loop a través de las particiones.
WHILE (1=1)
BEGIN
    FETCH NEXT
    FROM partitions
    INTO @objectid, @indexid, @partitionnum, @frag;
    IF @@FETCH_STATUS < 0 BREAK;

    SELECT @objectname = QUOTENAME(o.name), @schemaname = QUOTENAME(s.name)
    FROM sys.objects AS o
    JOIN sys.schemas AS s ON s.schema_id = o.schema_id
    WHERE o.object_id = @objectid;

    SELECT @indexname = QUOTENAME(name)
    FROM sys.indexes
    WHERE  object_id = @objectid AND index_id = @indexid;

    SELECT @partitioncount = COUNT(*)
    FROM sys.partitions
    WHERE object_id = @objectid AND index_id = @indexid;

    -- 30 es un punto de decisión arbitrario para cambiar entre reorganización y reconstrucción.

    IF @frag < 30.0
        SET @command = N'ALTER INDEX ' + @indexname + N' ON ' +
        @schemaname + N'.' + @objectname + N' REORGANIZE';
    ELSE IF @frag >= 30.0 AND @partitioncount <= 1
        SET @command = N'ALTER INDEX ' + @indexname + N' ON ' +
        @schemaname + N'.' + @objectname + N' REBUILD WITH (ONLINE = ON)';
    ELSE IF @frag >= 30.0 AND @partitioncount > 1
        SET @command = N'ALTER INDEX ' + @indexname + N' ON ' +
        @schemaname + N'.' + @objectname + N' REBUILD PARTITION=' +
        CAST(@partitionnum AS NVARCHAR(10)) + N' WITH (ONLINE = ON)';
    BEGIN TRY
        EXEC (@command);
        PRINT N'Executed: ' + @command;
    END TRY
    BEGIN CATCH
        PRINT N'Error executing: ' + @command;
        -- Puedes registrar el error o realizar cualquier otra acción aquí si es necesario.
    END CATCH
END;
-- Cerrar y liberar el cursor.
CLOSE partitions;
DEALLOCATE partitions;

insert into @datos
select * from  #work_to_do

-- Eliminar la tabla temporal.
DROP TABLE #work_to_do;

Print 'Defragmentados 10 registros---'
end
GO
~~~

 -->


<!-- trajandoahora -->
#
# 

# Defragmentación, al Rescate<a name="desfragmentacionalrescate"></a>

![Database Maintenance](https://greyphillips.com/Guides/assets/img/Database_Maintenance.png)

Para evitar el deterioro del rendimiento en nuestro servidor, debemos mantener nuestros índices en un estado de fragmentación óptimo. A continuación, se detallan los pasos necesarios para detectar y corregir la fragmentación de índices en SQL Server.

## Paso 1: Detectar Fragmentación en los Índices

Primero, necesitamos identificar la fragmentación en los índices de nuestra base de datos. Utilizaremos la vista de sistema `sys.dm_db_index_physical_stats`, encapsulada en la siguiente consulta SQL:

```sql
SELECT DB_NAME(database_id) AS DatabaseName, database_id, 
OBJECT_NAME(ips.object_id) AS TableName, ips.object_id,
i.name AS IndexName, i.index_id, p.rows,
ips.partition_number, index_type_desc, alloc_unit_type_desc, 
index_depth, index_level,
avg_fragmentation_in_percent, fragment_count, avg_fragment_size_in_pages, page_count,
avg_page_space_used_in_percent, record_count, ghost_record_count, version_ghost_record_count, min_record_size_in_bytes,
max_record_size_in_bytes, avg_record_size_in_bytes, forwarded_record_count
FROM sys.dm_db_index_physical_stats (DB_ID(), NULL, NULL , NULL, 'LIMITED') ips
INNER JOIN sys.indexes i ON i.object_id = ips.object_id AND i.index_id = ips.index_id
INNER JOIN sys.partitions p ON p.object_id = i.object_id AND p.index_id = i.index_id
WHERE avg_fragmentation_in_percent > 10.0 AND ips.index_id > 0 AND page_count > 1000
ORDER BY avg_fragmentation_in_percent DESC
```

Esta consulta devuelve información detallada sobre la fragmentación de los índices en la base de datos actual, permitiéndonos identificar los índices que requieren atención.

## Paso 2: Defragmentar los Índices

### Para SQL Server Standard Edition

En SQL Server Standard Edition, no podemos utilizar la opción `ONLINE=ON`. Utilizaremos el siguiente script para determinar si debemos reorganizar (`REORGANIZE`) o reconstruir (`REBUILD`) cada índice con problemas:

```sql
-- Ensure a USE statement has been executed first.
SET NOCOUNT ON;
DECLARE @objectid int;
DECLARE @indexid int;
DECLARE @partitioncount bigint;
DECLARE @schemaname nvarchar(130); 
DECLARE @objectname nvarchar(130); 
DECLARE @indexname nvarchar(130); 
DECLARE @partitionnum bigint;
DECLARE @partitions bigint;
DECLARE @frag float;
DECLARE @command nvarchar(4000); 
-- Conditionally select tables and indexes from the sys.dm_db_index_physical_stats function 
-- and convert object and index IDs to names.
SELECT
    object_id AS objectid,
    index_id AS indexid,
    partition_number AS partitionnum,
    avg_fragmentation_in_percent AS frag
INTO #work_to_do
FROM sys.dm_db_index_physical_stats (DB_ID(), NULL, NULL , NULL, 'LIMITED')
WHERE avg_fragmentation_in_percent > 10.0 AND index_id > 0 AND 
page_count > 1000;

-- Declare the cursor for the list of partitions to be processed.
DECLARE partitions CURSOR FOR SELECT * FROM #work_to_do;

-- Open the cursor.
OPEN partitions;

-- Loop through the partitions.
WHILE (1=1)
    BEGIN;
        FETCH NEXT
           FROM partitions
           INTO @objectid, @indexid, @partitionnum, @frag;
        IF @@FETCH_STATUS < 0 BREAK;
        SELECT @objectname = QUOTENAME(o.name), @schemaname = QUOTENAME(s.name)
        FROM sys.objects AS o
        JOIN sys.schemas as s ON s.schema_id = o.schema_id
        WHERE o.object_id = @objectid;
        SELECT @indexname = QUOTENAME(name)
        FROM sys.indexes
        WHERE  object_id = @objectid AND index_id = @indexid;
        SELECT @partitioncount = count (*)
        FROM sys.partitions
        WHERE object_id = @objectid AND index_id = @indexid;

-- 30 is an arbitrary decision point at which to switch between reorganizing and rebuilding.
     IF @frag < 30.0
       SET @command = N'ALTER INDEX ' + @indexname + N' ON ' + 
       @schemaname + N'.' + @objectname + N' REORGANIZE';
     IF @frag >= 30.0
         SET @command = N'ALTER INDEX ' + @indexname + N' ON ' + 
         @schemaname + N'.' + @objectname + N' REBUILD';
     IF @partitioncount > 1
            SET @command = @command + N' PARTITION=' + CAST
            (@partitionnum AS nvarchar(10));
        EXEC (@command);
        PRINT N'Executed: ' + @command;
    END;

-- Close and deallocate the cursor.
CLOSE partitions;
DEALLOCATE partitions;

-- Drop the temporary table.
DROP TABLE #work_to_do;
GO
```

### Para SQL Server Enterprise Edition

En SQL Server Enterprise Edition, podemos realizar la defragmentación en línea utilizando la opción `ONLINE = ON`, minimizando el bloqueo de las tablas:

```sql
-- Ensure a USE statement has been executed first.
SET NOCOUNT ON;
DECLARE @objectid INT;
DECLARE @indexid INT;
DECLARE @partitioncount BIGINT;
DECLARE @schemaname NVARCHAR(130);
DECLARE @objectname NVARCHAR(130);
DECLARE @indexname NVARCHAR(130);
DECLARE @partitionnum BIGINT;
DECLARE @partitions BIGINT;
DECLARE @frag FLOAT;
DECLARE @command NVARCHAR(4000);

-- Condición para seleccionar tablas e índices de la función sys.dm_db_index_physical_stats
-- y convertir los IDs de objetos e índices en nombres.
SELECT
    object_id AS objectid,
    index_id AS indexid,
    partition_number AS partitionnum,
    avg_fragmentation_in_percent AS frag
INTO #work_to_do
FROM sys.dm_db_index_physical_stats (DB_ID(), NULL, NULL, NULL, 'LIMITED')
WHERE avg_fragmentation_in_percent > 10.0 AND index_id > 0 AND
page_count > 1000;

-- Declarar el cursor para la lista de particiones a procesar.
DECLARE partitions CURSOR FOR SELECT * FROM #work_to_do;

-- Abrir el cursor.
OPEN partitions;

-- Loop a través de las particiones.
WHILE (1=1)
BEGIN
    FETCH NEXT
    FROM partitions
    INTO @objectid, @indexid, @partitionnum, @frag;
    IF @@FETCH_STATUS < 0 BREAK;

    SELECT @objectname = QUOTENAME(o.name), @schemaname = QUOTENAME(s.name)
    FROM sys.objects AS o
    JOIN sys.schemas AS s ON s.schema_id = o.schema_id
    WHERE o.object_id = @objectid;

    SELECT @indexname = QUOTENAME(name)
    FROM sys.indexes
    WHERE  object_id = @objectid AND index_id = @indexid;

    SELECT @partitioncount = COUNT(*)
    FROM sys.partitions
    WHERE object_id = @objectid AND index_id = @indexid;

    -- 30 es un punto de decisión arbitrario para cambiar entre reorganización y reconstrucción.
    IF @frag < 30.0
        SET @command = N'ALTER INDEX ' + @indexname + N' ON ' + 
        @schemaname + N'.' + @objectname + N' REORGANIZE';
    ELSE IF @frag >= 30.0 AND @partitioncount <= 1
        SET @command = N'ALTER INDEX ' + @indexname + N' ON ' + 
        @schemaname + N'.' + @objectname + N' REBUILD WITH (ONLINE = ON)';
    ELSE IF @frag >= 30.0 AND @partitioncount > 1
        SET @command = N'ALTER INDEX ' + @indexname + N' ON ' + 
        @schemaname + N'.' + @objectname + N' REBUILD PARTITION=' + 
        CAST(@partitionnum AS NVARCHAR(10)) + N' WITH (ONLINE = ON)';

    BEGIN TRY
        EXEC (@command);
        PRINT N'Executed: ' + @command;
    END TRY
    BEGIN CATCH
        PRINT N'Error executing: ' + @command;
        -- Puedes registrar el error o realizar cualquier otra acción aquí si es necesario.
    END CATCH
END;

-- Cerrar y liberar el cursor.
CLOSE partitions;
DEALLOCATE partitions;

-- Eliminar la tabla temporal.
DROP TABLE #work_to_do;
GO
```

### Optimización para Bases de Datos Muy Grandes

Para bases de datos muy grandes que necesitan ser defragmentadas sin interferir con las operaciones del servidor, se puede utilizar el siguiente script optimizado. Este script defragmenta en intervalos de 10 índices y excluye los que ya fueron leídos para mayor eficiencia:

```sql
-- Asegurarse de que se haya ejecutado una instrucción USE primero.
SET NOCOUNT ON;
DECLARE @objectid INT;
DECLARE @indexid INT;
DECLARE @partitioncount BIGINT;
DECLARE @schemaname NVARCHAR(130);
DECLARE @objectname NVARCHAR(130);
DECLARE @indexname NVARCHAR(130);
DECLARE @partitionnum BIGINT;
DECLARE @partitions BIGINT;
DECLARE @frag FLOAT;
DECLARE @command NVARCHAR(4000);

-- Condición para seleccionar tablas e índices de

 la función sys.dm_db_index_physical_stats
-- y convertir los IDs de objetos e índices en nombres.
DECLARE @datos TABLE
(
    id INT,
    indexs INT,
    partic INT,
    frag FLOAT
)

-- SI AL TABLA TEMPORAL EXISTE ELIMINALA.
BEGIN TRY
    DROP TABLE #work_to_do;
END TRY
BEGIN CATCH
    PRINT N'error executing';
END CATCH

WHILE EXISTS (
SELECT TOP 10
    object_id AS objectid,
    index_id AS indexid,
    partition_number AS partitionnum,
    avg_fragmentation_in_percent AS frag
FROM sys.dm_db_index_physical_stats (DB_ID(), NULL, NULL, NULL, 'LIMITED')
WHERE avg_fragmentation_in_percent > 10.0 AND index_id > 0 AND
page_count > 1000
AND object_id NOT IN
    (
        SELECT id FROM @datos
    )
)
BEGIN
    SELECT TOP 10
        object_id AS objectid,
        index_id AS indexid,
        partition_number AS partitionnum,
        avg_fragmentation_in_percent AS frag
    INTO #work_to_do
    FROM sys.dm_db_index_physical_stats (DB_ID(), NULL, NULL, NULL, 'LIMITED')
    WHERE avg_fragmentation_in_percent > 10.0 AND index_id > 0 AND
    page_count > 1000
    AND object_id NOT IN
    (
        SELECT id FROM @datos
    );

    -- Declarar el cursor para la lista de particiones a procesar.
    DECLARE partitions CURSOR FOR SELECT * FROM #work_to_do;
    -- Abrir el cursor.
    OPEN partitions;

    -- Loop a través de las particiones.
    WHILE (1=1)
    BEGIN
        FETCH NEXT
        FROM partitions
        INTO @objectid, @indexid, @partitionnum, @frag;
        IF @@FETCH_STATUS < 0 BREAK;

        SELECT @objectname = QUOTENAME(o.name), @schemaname = QUOTENAME(s.name)
        FROM sys.objects AS o
        JOIN sys.schemas AS s ON s.schema_id = o.schema_id
        WHERE o.object_id = @objectid;

        SELECT @indexname = QUOTENAME(name)
        FROM sys.indexes
        WHERE  object_id = @objectid AND index_id = @indexid;

        SELECT @partitioncount = COUNT(*)
        FROM sys.partitions
        WHERE object_id = @objectid AND index_id = @indexid;

        -- 30 es un punto de decisión arbitrario para cambiar entre reorganización y reconstrucción.
        IF @frag < 30.0
            SET @command = N'ALTER INDEX ' + @indexname + N' ON ' +
            @schemaname + N'.' + @objectname + N' REORGANIZE';
        ELSE IF @frag >= 30.0 AND @partitioncount <= 1
            SET @command = N'ALTER INDEX ' + @indexname + N' ON ' +
            @schemaname + N'.' + @objectname + N' REBUILD WITH (ONLINE = ON)';
        ELSE IF @frag >= 30.0 AND @partitioncount > 1
            SET @command = N'ALTER INDEX ' + @indexname + N' ON ' +
            @schemaname + N'.' + @objectname + N' REBUILD PARTITION=' +
            CAST(@partitionnum AS NVARCHAR(10)) + N' WITH (ONLINE = ON)';
        BEGIN TRY
            EXEC (@command);
            PRINT N'Executed: ' + @command;
        END TRY
        BEGIN CATCH
            PRINT N'Error executing: ' + @command;
            -- Puedes registrar el error o realizar cualquier otra acción aquí si es necesario.
        END CATCH
    END;
    -- Cerrar y liberar el cursor.
    CLOSE partitions;
    DEALLOCATE partitions;

    INSERT INTO @datos
    SELECT * FROM  #work_to_do

    -- Eliminar la tabla temporal.
    DROP TABLE #work_to_do;

    PRINT 'Defragmentados 10 registros---'
END
GO
```

### Consideraciones Finales

- **Mantenimiento Regular:** Realizar estas operaciones de manera regular ayuda a mantener el rendimiento óptimo de la base de datos.
- **Evaluación de Fragmentación:** Ajustar los umbrales de fragmentación (`avg_fragmentation_in_percent`) y el tamaño mínimo de página (`page_count`) según las necesidades específicas de su entorno.
- **Planificación de Mantenimiento:** Programar estas tareas durante períodos de baja actividad para minimizar el impacto en los usuarios.


# 




