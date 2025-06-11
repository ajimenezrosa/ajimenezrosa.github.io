#### **5. Performance**
* 5.1 [Performance de la base de datos](#performance)  
* 5.2 [Consultar última fecha de acceso de login en MS SQL Server](#consultaulfechaacceso)  
* 5.3 [Identificar latencia de disco en SQL Server](#disklatency)  
* 5.4 [Uso de memoria de SQL Server por base de datos y objeto](#disklatency2)  
* 5.5 [Listar todos los procedimientos almacenados de una base de datos](#procalmacenados)  
    - 5.5.1 [Buscar las consultas TOP N](#buscarconsultatop)  
    - 5.5.2 [Espacios en disco ocupados por base de datos](#espacioendiscodb)  
    - 5.5.3 [Vía 2: Rendimiento de las consultas](#rendimientoconsultas2)  
    - 5.5.4 [Top 10 procedimientos almacenados con mayor tiempo transcurrido](#10procmayortiemeje)  
    - 5.5.5 [Consultas SQL más ejecutadas](#lasconsultassqlmasejecutadas)  
    - 5.5.6 [Consultas SQL con mayor consumo de CPU](#consultassqlmayorconsumodecpu)  
    - 5.6 [Consulta SQL para Identificar Usuarios Ejecutando Procedimientos Almacenados](#5.6)



    #
## 
# Consultar ultima fecha de acceso Login MS SQL Server<a name="consultaulfechaacceso"></a>

#### Es muy posible que en algún momento hayas pensado en que estaría bien saber cuándo ha sido el último acceso a una determinada tabla de tu base de datos SQL Server, ¿no se os ocurre ningún caso? Imaginemos que hemos modificado cierto código provocando que una tabla deje de utilizarse y pueda ser eliminada , ¿estamos seguros que ningún otro código o aplicación acceden a esa tabla? A continuación os explicaré cómo podemos saber la última vez que una tabla ha sido accedida en SQL Server.


###### query 1
# 

~~~SQL

SELECT -- [id]
      [ServidorDB]
      ,[Tabla]
      ,max([Fecha_Acceso]) Fecha_Acceso
      --,[fecha_Ejecucion]
  FROM [Db_Analisis].[TablasFechasAccesos]
    where Fecha_Acceso is not null
      --and [Tabla] = 
      and [ServidorDB] = 'inabima'
    group by
          [ServidorDB]
      ,[Tabla]

    order by Fecha_Acceso desc

GO
~~~
# 

###### query 2
# 

~~~SQL
-- Comprobamos los accesos
SELECT tab.name AS Tablename,
       user_seeks, user_scans, user_lookups, user_updates,
       last_user_seek, last_user_scan, last_user_lookup, last_user_update
FROM sys.dm_db_index_usage_stats ius 
INNER JOIN sys.tables tab ON (tab.object_id = ius.object_id)
WHERE database_id = DB_ID(N'AdventureWorks')
  AND tab.name = 'Employee'
~~~
# 


# B.Devolver agregados de recuentos de filas para una consulta
#### En el ejemplo siguiente se devuelve información de agregado de recuento de filas (filas totales, filas mínimas, filas máximas y últimas filas) para las consultas.
# 

~~~sql
SELECT qs.execution_count,  
    SUBSTRING(qt.text,qs.statement_start_offset/2 +1,   
                 (CASE WHEN qs.statement_end_offset = -1   
                       THEN LEN(CONVERT(nvarchar(max), qt.text)) * 2   
                       ELSE qs.statement_end_offset end -  
                            qs.statement_start_offset  
                 )/2  
             ) AS query_text,   
     qt.dbid, dbname= DB_NAME (qt.dbid), qt.objectid,   
     qs.total_rows, qs.last_rows, qs.min_rows, qs.max_rows  
FROM sys.dm_exec_query_stats AS qs   
CROSS APPLY sys.dm_exec_sql_text(qs.sql_handle) AS qt   
WHERE qt.text like '%SELECT%'    
--and objectid = 562153098
ORDER BY qs.execution_count DESC;  
~~~
# 


## Documentación sobre la Latencia de Discos y Cómo Manejarla en SQL Server<a name="disklatency"></a>

<img src="https://acf.geeknetic.es/imagenes/auto/23/11/10/6ik-micron-lanza-la-memoria-de-baja-latencia-y-velocidades-de-hasta-8.000-mhz-para-servidores-en-capacid.png?format=jpg&name=large" alt="JuveR" width="800px">

**Autor: Jose Alejandro Jimenez Rosa**

#### Introducción

La latencia de discos es un aspecto crítico en la gestión del rendimiento de sistemas de almacenamiento, especialmente en servidores SQL. La latencia se refiere al tiempo que transcurre desde que se envía una solicitud de lectura o escritura al disco hasta que la operación se completa. Una alta latencia puede llevar a un rendimiento deficiente del sistema, afectando la productividad y la eficiencia operativa. Esta documentación explora en detalle qué es la latencia de discos, sus causas, cómo medirla y las estrategias para reducirla en el contexto de SQL Server.

#### ¿Qué es la Latencia de Discos?

La latencia de discos es el retraso entre una solicitud de E/S (Entrada/Salida) y la respuesta del disco. Se mide en milisegundos (ms) y puede verse influenciada por varios factores, incluyendo la velocidad del disco, la carga de trabajo, la interfaz de conexión y la configuración del sistema. La latencia es un componente esencial del tiempo de respuesta total del sistema, y su reducción es crucial para mejorar el rendimiento general.

#### Causas de la Latencia de Discos

1. **Velocidad del Disco**: Los discos duros (HDD) mecánicos tienden a tener mayor latencia en comparación con las unidades de estado sólido (SSD) debido a sus partes móviles.
2. **Carga de Trabajo**: Una alta carga de trabajo puede aumentar la latencia debido a la cola de solicitudes de E/S.
3. **Interfaz de Conexión**: La interfaz del disco (SATA, SAS, NVMe) puede afectar significativamente la latencia.
4. **Configuración del Sistema**: La configuración del sistema operativo y del SQL Server también puede influir en la latencia.

#### Cómo Medir la Latencia de Discos en SQL Server

Existen varias formas de verificar problemas de latencia de discos en SQL Server, utilizando vistas de gestión dinámica (DMVs) y herramientas como `dbatools`.

##### Uso de DMVs

Desde SQL Server 2005, Microsoft introdujo la vista de gestión dinámica `sys.dm_io_virtual_file_stats`, que reporta actividades de lectura y escritura de discos para archivos de datos y de registros.

##### Consulta para Medir Latencia

A continuación, se presenta una consulta basada en el trabajo de Paul Randal de SQLSkills, con una columna adicional para categorizar rápidamente los valores de latencia.

~~~sql
SELECT
   [ReadLatency] =
        CASE WHEN [num_of_reads] = 0
            THEN 0 ELSE ([io_stall_read_ms] / [num_of_reads]) END,
   [WriteLatency] =
        CASE WHEN [num_of_writes] = 0
            THEN 0 ELSE ([io_stall_write_ms] / [num_of_writes]) END,
   [Latency] =
        CASE WHEN ([num_of_reads] = 0 AND [num_of_writes] = 0)
            THEN 0 ELSE ([io_stall] / ([num_of_reads] + [num_of_writes])) END,
   [Latency Desc] = 
         CASE 
            WHEN ([num_of_reads] = 0 AND [num_of_writes] = 0) THEN 'N/A' 
            ELSE 
               CASE WHEN ([io_stall] / ([num_of_reads] + [num_of_writes])) < 2 THEN 'Excellent'
                    WHEN ([io_stall] / ([num_of_reads] + [num_of_writes])) < 6 THEN 'Very good'
                    WHEN ([io_stall] / ([num_of_reads] + [num_of_writes])) < 11 THEN 'Good'
                    WHEN ([io_stall] / ([num_of_reads] + [num_of_writes])) < 21 THEN 'Poor'
                    WHEN ([io_stall] / ([num_of_reads] + [num_of_writes])) < 101 THEN 'Bad'
                    WHEN ([io_stall] / ([num_of_reads] + [num_of_writes])) < 501 THEN 'Yikes!'
               ELSE 'YIKES!!'
               END 
         END, 
   [AvgBPerRead] =
        CASE WHEN [num_of_reads] = 0
            THEN 0 ELSE ([num_of_bytes_read] / [num_of_reads]) END,
   [AvgBPerWrite] =
        CASE WHEN [num_of_writes] = 0
            THEN 0 ELSE ([num_of_bytes_written] / [num_of_writes]) END,
   [AvgBPerTransfer] =
        CASE WHEN ([num_of_reads] = 0 AND [num_of_writes] = 0)
            THEN 0 ELSE
                (([num_of_bytes_read] + [num_of_bytes_written]) /
                ([num_of_reads] + [num_of_writes])) END,
   LEFT ([mf].[physical_name], 2) AS [Drive],
   DB_NAME ([vfs].[database_id]) AS [DB],
   [mf].[physical_name]
FROM
   sys.dm_io_virtual_file_stats (NULL,NULL) AS [vfs]
   JOIN sys.master_files AS [mf]
   ON [vfs].[database_id] = [mf].[database_id]
      AND [vfs].[file_id] = [mf].[file_id]
ORDER BY [Latency] DESC;
GO
~~~

Esta consulta ayuda a interpretar rápidamente los resultados de latencia. Los valores de latencia se clasifican de la siguiente manera:

| Latencia       | Descripción  |
|----------------|--------------|
| 0 a 1 ms       | Excelente    |
| 2 a 5 ms       | Muy bueno    |
| 6 a 10 ms      | Bueno        |
| 11 a 20 ms     | Pobre        |
| 21 a 100 ms    | Malo         |
| 101 a 500 ms   | ¡Ay!         |
| más de 500 ms  | ¡¡AY!!       |

##### Uso de dbatools

`dbatools.io` ofrece una herramienta llamada `Test-DbaDiskSpeed`, que realiza pruebas de velocidad del disco y proporciona un informe detallado.

~~~cmd
Test-DbaDiskSpeed -SqlInstance localhost -SqlCredential sa | Format-Table -Property Database, SizeGB, FileName, FileID, FileType, DiskLocation, Reads, AverageReadStall, ReadPerformance, Writes, AverageWriteStall, WritePerformance, 'Avg Overall Latency' | Out-String -Width 4096 |out-file c:\temp\DbaDiskSpeed.txt
~~~

Este comando ejecuta una prueba de velocidad de disco en la instancia de SQL Server especificada y genera un archivo de salida con los resultados.

#### Estrategias para Reducir la Latencia de Discos

1. **Actualizar a SSDs**: Los discos de estado sólido ofrecen menor latencia en comparación con los HDDs tradicionales.
2. **Optimizar la Configuración del Sistema**: Ajustar configuraciones del sistema operativo y del SQL Server para optimizar el rendimiento de E/S.
3. **Distribuir la Carga de Trabajo**: Balancear la carga de trabajo entre varios discos para evitar cuellos de botella.
4. **Monitorización Continua**: Utilizar herramientas y scripts para monitorear continuamente la latencia y tomar acciones proactivas.

#### Conclusión

La gestión de la latencia de discos es esencial para mantener un rendimiento óptimo en los servidores SQL. Medir y entender la latencia mediante DMVs y herramientas como `dbatools` permite a los administradores identificar cuellos de botella y aplicar estrategias para mejorar el rendimiento. Mantener una baja latencia asegura que el sistema responda de manera eficiente, mejorando así la productividad y la satisfacción del usuario final.











# 
# SQL Server memory use by database and object<a name="disklatency2"></a>
## Problem
#### For many people, the way that SQL Server uses memory can be a bit of an enigma. A large percentage of the memory your SQL Server instance utilizes is consumed by buffer pool (essentially, data). Without a lot of digging, it can be hard to tell which of your databases consume the most buffer pool memory, and even more so, which objects within those databases. This information can be quite useful, for example, if you are considering an application change to split your database across multiple servers, or trying to identify databases that are candidates for consolidation.

## Solution
#### A Dynamic Management View (DMV) introduced in SQL Server 2005, called sys.dm_os_buffer_descriptors, contains a row for every page that has been cached in the buffer pool. Using this DMV, you can quickly determine which database(s) are utilizing the majority of your buffer pool memory. Once you have identified the databases that are occupying much of the buffer pool, you can drill into them individually. In the following query, I first find out exactly how big the buffer pool currently is (from the DMV sys.dm_os_performance_counters), allowing me to calculate the percentage of the buffer pool being used by each database:
# 
# 

~~~sql
-- Note: querying sys.dm_os_buffer_descriptors
-- requires the VIEW_SERVER_STATE permission.

DECLARE @total_buffer INT;

SELECT @total_buffer = cntr_value
FROM sys.dm_os_performance_counters 
WHERE RTRIM([object_name]) LIKE '%Buffer Manager'
AND counter_name = 'Database Pages';

;WITH src AS
(
  SELECT 
  database_id, db_buffer_pages = COUNT_BIG(*)
  FROM sys.dm_os_buffer_descriptors
  --WHERE database_id BETWEEN 5 AND 32766
  GROUP BY database_id
)
SELECT
[db_name] = CASE [database_id] WHEN 32767 
THEN 'Resource DB' 
ELSE DB_NAME([database_id]) END,
db_buffer_pages,
db_buffer_MB = db_buffer_pages / 128,
db_buffer_percent = CONVERT(DECIMAL(6,3), 
db_buffer_pages * 100.0 / @total_buffer)
FROM src
ORDER BY db_buffer_MB DESC; 
~~~
# 
# 


#### In the above query, I've included the system databases, but you can exclude them by uncommenting the WHERE clause within the CTE. Note that the actual filter may need to change with future versions of SQL Server; for example, in SQL Server 2012, there is a new database for Integration Services called SSISDB. You may want to keep an eye on system databases just to have a complete picture, seeing as there isn't much you can do about their buffer pool usage anyway - unless you are using master or msdb for your own custom objects.

#### That all said, here are partial results from an instance on my local virtual machine:


<img src="https://www.mssqltips.com/tipImages2/2393_memory_a.png?format=jpg&name=large" alt="JuveR" width="800px">

#### Clearly, the SQLSentry database - while only representing 258 MB - occupies about 70% of my buffer pool for this instance. So now I know that I can drill into that database specifically if I want to track down the objects that are taking up most of that memory. You can once again use the sys.dm_os_buffer_descriptors only this time, instead of aggregating the page counts at the database level, we can utilize a set of catalog views to determine the number of pages (and therefore amount of memory) dedicated to each object.
# 
# 

~~~sql
USE SQLSentry;
GO

;WITH src AS
(
  SELECT
  [Object] = o.name,
  [Type] = o.type_desc,
  [Index] = COALESCE(i.name, ''),
  [Index_Type] = i.type_desc,
  p.[object_id],
  p.index_id,
  au.allocation_unit_id
  FROM sys.partitions AS p
  INNER JOIN sys.allocation_units AS au ON p.hobt_id = au.container_id
  INNER JOIN sys.objects AS o ON p.[object_id] = o.[object_id]
  INNER JOIN sys.indexes AS i ON o.[object_id] = i.[object_id] AND p.index_id = i.index_id
  WHERE
  au.[type] IN (1,2,3)
  AND o.is_ms_shipped = 0
)
SELECT
src.[Object],
src.[Type],
src.[Index],
src.Index_Type,
buffer_pages = COUNT_BIG(b.page_id),
buffer_mb = COUNT_BIG(b.page_id) / 128
FROM src
INNER JOIN sys.dm_os_buffer_descriptors AS b ON src.allocation_unit_id = b.allocation_unit_id
WHERE
b.database_id = DB_ID()
GROUP BY
src.[Object],
src.[Type],
src.[Index],
src.Index_Type
ORDER BY
buffer_pages DESC;
~~~
# 
# 
#### Here are the results from this database. Notice that I've captured both clustered and non-clustered indexes, for clustered tables and heaps, and for illustrative purposes I have also created an indexed view.

<img src="https://www.mssqltips.com/tipImages2/2393_memory_b.png?format=jpg&name=large" alt="JuveR" width="800px">

#### Please keep in mind that the buffer pool is in constant flux, and that this latter query has explicitly filtered out system objects, so the numbers won't always add up nicely. Still, this should give you a fairly good idea of which objects are using your buffer pool the most.

#### When investigating the performance of your servers, buffer pool data is only a part of the picture, but it's one that is often overlooked. Including this data will help you to make better and more informed decisions about direction and scale.


# 
# Listar todos los Procedimientos Almacenados de una Base de Datos<a name="procalmacenados"></a>
# 

~~~sql
SELECT ROUTINE_NAME FROM INFORMATION_SCHEMA.ROUTINES 
   WHERE ROUTINE_TYPE = 'PROCEDURE'
   ORDER BY ROUTINE_NAME
~~~
# 
# 

# 

# A.Buscar las consultas TOP N<a name="buscarconsultatop"></a>
#### En el siguiente ejemplo se devuelve información acerca de las cinco primeras consultas clasificadas por el promedio de tiempo de CPU. Este ejemplo agrega las consultas según su hash de consulta para que las consultas lógicamente equivalentes se agrupen según su consumo acumulado de los recursos.
# 

~~~sql
SELECT TOP 5 query_stats.query_hash AS "Query Hash",   @@SERVERNAME ,
    SUM(query_stats.total_worker_time) / SUM(query_stats.execution_count) AS "Avg CPU Time",  
    MIN(query_stats.statement_text) AS "Statement Text"  
FROM   
    (SELECT QS.*,   
    SUBSTRING(ST.text, (QS.statement_start_offset/2) + 1,  
    ((CASE statement_end_offset   
        WHEN -1 THEN DATALENGTH(ST.text)  
        ELSE QS.statement_end_offset END   
            - QS.statement_start_offset)/2) + 1) AS statement_text  
     FROM sys.dm_exec_query_stats AS QS  
     CROSS APPLY sys.dm_exec_sql_text(QS.sql_handle) as ST) as query_stats  
GROUP BY query_stats.query_hash  
ORDER BY 2 DESC; 
~~~
# 

# 
# Espacios en disco y ocupados por db<a name="espacioendiscodb"></a>
# 

~~~sql
/*
SQL SERVER – Disk Space Monitoring – Detecting Low Disk Space on Server
*/
EXEC MASTER..xp_fixeddrives
GO

/*
El query en cuestion nos presenta 3 columnas Logical_name, Drive letter y FreeSapce en MB.
*/

SELECT DISTINCT dovs.logical_volume_name AS LogicalName,
dovs.volume_mount_point AS Drive,
CONVERT(INT,dovs.available_bytes/1048576.0) AS FreeSpaceInMB
,convert(varchar(10), getdate(),120) Date_Verif
FROM sys.master_files mf
CROSS APPLY sys.dm_os_volume_stats(mf.database_id, mf.FILE_ID) dovs
ORDER BY FreeSpaceInMB ASC
GO
--We can further modify above query to also include database name in the query as well.
SELECT DISTINCT DB_NAME(dovs.database_id) DBName,
dovs.logical_volume_name AS LogicalName,
dovs.volume_mount_point AS Drive,
CONVERT(INT,dovs.available_bytes/1048576.0) AS FreeSpaceInMB
FROM sys.master_files mf
CROSS APPLY sys.dm_os_volume_stats(mf.database_id, mf.FILE_ID) dovs
ORDER BY FreeSpaceInMB ASC
GO

--If you see a database name, multiple times, it is because your 
--database has multiple files and they are on different drives. You 
--can modify above query one more time to even include the details of actual file location.

SELECT DISTINCT @@SERVERNAME "ServerName", DB_NAME(dovs.database_id) DBName,
        mf.physical_name PhysicalFileLocation,
        dovs.logical_volume_name AS LogicalName,
        dovs.volume_mount_point AS Drive,
        CONVERT(INT,dovs.available_bytes/1048576.0) AS FreeSpaceInMB
        ,convert(varchar(10), getdate(),120) Date_Verif
FROM sys.master_files mf
        CROSS APPLY sys.dm_os_volume_stats(mf.database_id, mf.FILE_ID) dovs
ORDER BY FreeSpaceInMB ASC
GO
~~~
# 
# 

# Vía 2: Rendimiento de las consultas<a name="rendimientoconsultas2"></a>
# Seguimiento de SP
#### Al realizar el seguimiento de su aplicación SQL Server, vale la pena familiarizarse con los procedimientos almacenados que se usan para el seguimiento. Si usa una interfaz gráfica (SQL Server Profiler) para realizar el seguimiento, puede aumentar la carga del sistema entre un 15 y un 25 por ciento. 

#### Si puede usar procedimientos almacenados en su seguimiento, este valor puede reducirse a la mitad.
#### Cuando sé que el sistema tiene un cuello de botella en algún lugar y deseo determinar qué instrucciones SQL  actuales están probando problemas en el servidor, ejecuto la consulta siguiente. Esta consulta me permite  ver las distintas instrucciones y los recursos que están usando actualmente, así como instrucciones que  necesitan ser revisadas para mejorar el rendimiento. Para obtener más información acerca de los seguimientos  de SQL, consulte msdn2.microsoft.com/ms191006.aspx.
# 

~~~sql

/*
Alejandro Jimenez 
01 de agosto del 2016

Vía 2: Rendimiento de las consultas
Seguimiento de SP
Al realizar el seguimiento de su aplicación SQL Server, vale la pena familiarizarse con los procedimientos 
almacenados que se usan para el seguimiento. Si usa una interfaz gráfica (SQL Server Profiler) para realizar 
el seguimiento, puede aumentar la carga del sistema entre un 15 y un 25 por ciento. Si puede usar procedimientos 
almacenados en su seguimiento, este valor puede reducirse a la mitad.
Cuando sé que el sistema tiene un cuello de botella en algún lugar y deseo determinar qué instrucciones SQL
 actuales están probando problemas en el servidor, ejecuto la consulta siguiente. Esta consulta me permite 
 ver las distintas instrucciones y los recursos que están usando actualmente, así como instrucciones que 
 necesitan ser revisadas para mejorar el rendimiento. Para obtener más información acerca de los seguimientos 
 de SQL, consulte msdn2.microsoft.com/ms191006.aspx.
*/

SELECT  
    substring(text,qs.statement_start_offset/2 
        ,(CASE     
            WHEN qs.statement_end_offset = -1 THEN len(convert(nvarchar(max), text)) * 2  
            ELSE qs.statement_end_offset  
        END - qs.statement_start_offset)/2)  
    ,qs.plan_generation_num as recompiles 
    ,qs.execution_count as execution_count 
    ,qs.total_elapsed_time - qs.total_worker_time as total_wait_time 
    ,qs.total_worker_time as cpu_time 
    ,qs.total_logical_reads as reads 
    ,qs.total_logical_writes as writes 
FROM sys.dm_exec_query_stats qs 
    CROSS APPLY sys.dm_exec_sql_text(qs.sql_handle) st 
    LEFT JOIN sys.dm_exec_requests r  
        ON qs.sql_handle = r.sql_handle 
ORDER BY 3 DESC 
~~~
# 
# 