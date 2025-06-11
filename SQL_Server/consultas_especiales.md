## **7. Consultas Especiales**
* 7.1 [Tablas que contienen un nombre de campo específico](#buscarnombrecampo)  
* 7.2 [Listar todos los objetos de una base de datos](#14.3)  
* 7.3 [Query de la última vez que se ejecutó un procedimiento](#ultejecproc1)  
* 7.4 [Última vez que se usó una tabla](#ultejecproc3)  
* 7.5 [Última vez que se utilizó un índice](#ultejecproc2)  
* 7.6 [Cuánto ocupan mis tablas](#cuantoocupantablas)  
<!-- * 7.7 [Defragmentación](#desfragmentacionalrescate)   -->
* 7.8 [Detectar actividad del servidor](#dectectandoactenservidor)  
    - 7.8.1 [Información sobre sesiones en tiempo real](#20.1)  
* 7.9 [Cuántos cores tiene mi base de datos](#cuantoscoretengo)  
* 7.10 [Query de listado de tablas con su tamaño y cantidad de registros](#listadotablas)  

* 7.11 [Query para Monitorear Sesiones Activas y Consultas en Ejecución en SQL Server](#7.11)
* 7.12 [Buscar Caracteres Especiales en una Tabla de SQL Server](#7.12)
* 7.13 [Detección y Análisis de Workers en SQL Server](#7.13)
* 7.14 [Monitorización de Sesiones Activas en SQL Server](#7.14)

#### Análisis de Procedimientos Almacenados en SQL Server
- [Identificar Procedimientos Almacenados con Mayor Tiempo de Duración](#identificar-procedimientos-almacenados-con-mayor-tiempo-de-duracion)
- [Buscar un Procedimiento Almacenado en Todas las Bases de Datos](#buscar-un-procedimiento-almacenado-en-todas-las-bases-de-datos)



# Tablas que Contienen un mombre de Campo.<a name="buscarnombrecampo"></a>
#### Es posible que quieres saber en cuales tablas esta el campo SocialSecurity , iva ect. Pero seria ineficiente por no decir (una locura ) buscarlos Uno por uno.

#### anexo un query que puede resultarte util.
# 

~~~sql
declare @Campo varchar(50) = 'his'
SELECT 
    Inf.TABLE_CATALOG
    ,Inf.TABLE_SCHEMA
    ,inf.TABLE_NAME 
    ,inf.COLUMN_NAME
    ,inf.data_type+'('+ convert(varchar(4), inf.CHARACTER_MAXIMUM_LENGTH)+')' Data_Type
    --,inf.CHARACTER_MAXIMUM_LENGTH
FROM INFORMATION_SCHEMA.COLUMNS  as Inf
      Join sys.tables tbl 
            on Inf.TABLE_NAME = tbl.name
        
where Column_name like '%'+  @Campo + '%'
    and TABLE_SCHEMA = 'dbo'
    and CHARACTER_MAXIMUM_LENGTH <20

order by TABLE_NAME
~~~
# 



# Listado de todos los objetos de una base de datos<a name="14.3"></a>
    
#### Para obtener los enlaces de servidor (linked servers) y otros objetos similares de una base de datos en SQL Server, puedes consultar el sistema de metadatos del servidor. Puedes utilizar consultas en SQL para acceder a esta información. Aquí tienes un ejemplo de cómo hacerlo:

~~~sql
-- Consulta para obtener los linked servers y otros objetos similares
SELECT
    name AS Nombre_Objeto,
    CASE 
        WHEN type_desc = 'SQL_LINKED_SERVER' THEN 'Linked Server'
        WHEN type_desc = 'SQL_SERVER_LOGIN' THEN 'Login'
        WHEN type_desc = 'SQL_SCALAR_FUNCTION' THEN 'Función Escalar'
        WHEN type_desc = 'SQL_STORED_PROCEDURE' THEN 'Procedimiento Almacenado'
        WHEN type_desc = 'SQL_TRIGGER' THEN 'Trigger'
        WHEN type_desc = 'SQL_VIEW' THEN 'Vista'
        -- Agrega más tipos de objetos según sea necesario
        ELSE type_desc
    END AS Tipo_Objeto
FROM sys.objects
WHERE type_desc IN ('SQL_LINKED_SERVER', 'SQL_SERVER_LOGIN', 'SQL_SCALAR_FUNCTION', 'SQL_STORED_PROCEDURE', 'SQL_TRIGGER', 'SQL_VIEW')
~~~
#### Esta consulta seleccionará todos los objetos de la base de datos que sean linked servers, logins, funciones escalares, procedimientos almacenados, triggers o vistas, y mostrará su nombre y tipo correspondiente.

#### Por favor, ten en cuenta que necesitas tener permisos suficientes en el servidor SQL Server para ejecutar esta consulta y acceder a la información del sistema de metadatos.



#

#
# Query de la ultima vez que se ejecuto en procedimiento<a name="ultejecproc1"></a>

#### Query para determiner la ultima vez que se ejecuto un procedimiento en una base de datos
#### Para esto buscamos en la tabla sys.dm.exec_procedure_stats
# 

~~~sql
/*
Alejandro Jimenez Rosa
AJ Miercoles 27 de julio del 2016 
para resolver problema en produccion (verificacion de procedimiento )
*/

declare @procedimiento varchar(100)
set @procedimiento = 'sigXPNumerarCorrespondenciaExterna'

SELECT d.object_id, d.database_id, OBJECT_NAME(object_id, database_id) 'proc name',   DB_NAME(),
    d.cached_time, d.last_execution_time, d.total_elapsed_time,  
    d.total_elapsed_time/d.execution_count AS [avg_elapsed_time],  
    d.last_elapsed_time, d.execution_count  
FROM sys.dm_exec_procedure_stats AS d  
where OBJECT_NAME(object_id, database_id)  = @procedimiento 
ORDER BY last_execution_time desc
~~~
# 


# Cuando fue la ultima que se uso una tabla?<a name="ultejecproc3"></a>
#### Hace rato que no escribia, he andado como siempre en mucha cosa. Estoy jugando un poco con PostGreSQL y Azure, seguramente empezare a incluir esa informacion en futuras entradas a este blog.

#### La respuesta  a la pregunta del titulo me ha servido muchas veces como administrador de una base de datos a lo largo de los años.
#### Esta consulta esta basada en una vista de systema que analiza el uso de los indices de nuestras tablas.
# 

~~~sql
declare @dbname VARCHAR(50) = 'INABIMA'

SELECT  
        DB_NAME(a.database_id) Database_Name ,
        b.name Table_Name ,
        MAX(ISNULL(last_user_update,'2001-01-01')) last_user_update ,
        MAX(ISNULL(last_user_seek,'2001-01-01')) last_user_seek ,
        MAX(ISNULL(last_user_scan,'2001-01-01')) last_user_scan ,
        MAX(ISNULL(last_user_lookup,'2001-01-01')) last_user_lookup
FROM    sys.dm_db_index_usage_stats a
        INNER JOIN sys.tables b ON b.object_id = a.object_id
        INNER JOIN sys.indexes c ON c.object_id = a.object_id
                                    AND c.index_id = a.index_id
WHERE DB_NAME(a.database_id) = @dbname
GROUP BY a.database_id ,
        b.name
ORDER BY a.database_id ,
        b.name 
~~~
# 


# Utilizando este mismo codigo podemos determinar cuando fue la ultima vez que se utilizo uno de nuestros indices<a name="ultejecproc2"></a>
# 

~~~sql
SELECT  DB_NAME(a.database_id) Database_Name ,
        b.name Table_Name ,
        c.name Index_Name ,
        MAX(ISNULL(last_user_update,'2001-01-01')) last_user_update ,
        MAX(ISNULL(last_user_seek,'2001-01-01')) last_user_seek ,
        MAX(ISNULL(last_user_scan,'2001-01-01')) last_user_scan ,
        MAX(ISNULL(last_user_lookup,'2001-01-01')) last_user_lookup
FROM    sys.dm_db_index_usage_stats a
        INNER JOIN sys.tables b ON b.object_id = a.object_id
        INNER JOIN sys.indexes c ON c.object_id = a.object_id
                                    AND c.index_id = a.index_id
WHERE   a.database_id = DB_ID()
GROUP BY a.database_id ,
        b.name ,
        c.name
ORDER BY a.database_id ,
        b.name ,
        c.name;
~~~
# 





# Cuanto Ocupan mis tablas<a name="cuantoocupantablas"></a> 


<img src="https://1.bp.blogspot.com/-V5aQzyPZa8k/XkHd2064YtI/AAAAAAAACmw/_me-o2Wq7BQ0r-RDNeeWaPQ68aJU_iPMQCLcBGAsYHQ/s640/tama%25C3%25B1o-base-de-datos-sql-server.png?format=jpg&name=large" alt="JuveR" width="800px">

###### espacio fisico  Alejadnro Jimenez
# 
#### Qiery que trae cuantos rows tenemos asi como cuantos mb tengo ocupados por esa tabla
~~~sql
SELECT

t.NAME AS Tabla,

s.Name AS Esquema,

p.rows AS NumeroDeFilas,

CAST(ROUND(((SUM(a.total_pages) * 8) / 1024.00), 2) AS NUMERIC(36, 2)) AS TotalEspacio_MB,

CAST(ROUND(((SUM(a.used_pages) * 8) / 1024.00), 2) AS NUMERIC(36, 2)) AS EspacioUtilizado_MB,

CAST(ROUND(((SUM(a.total_pages) - SUM(a.used_pages)) * 8) / 1024.00, 2) AS NUMERIC(36, 2)) AS EspacioNoUtilizado_MB

FROM

sys.tables t

INNER JOIN sys.indexes i ON t.OBJECT_ID = i.object_id

INNER JOIN sys.partitions p ON i.object_id = p.OBJECT_ID AND i.index_id = p.index_id

INNER JOIN sys.allocation_units a ON p.partition_id = a.container_id

LEFT OUTER JOIN sys.schemas s ON t.schema_id = s.schema_id

GROUP BY t.Name, s.Name, p.Rows

ORDER BY TotalEspacio_MB desc
~~~

####  query anterio este fue sustituido por de arriba

~~~sql

select name
  ,(select top 1 row_count from sys.dm_db_partition_stats where object_id=s.object_id)
  ,modify_date
  ,(select  convert(decimal(8,2),(SUM (	CASE
WHEN (index_id < 2) THEN (in_row_data_page_count + lob_used_page_count + row_overflow_used_page_count)
ELSE lob_used_page_count + row_overflow_used_page_count
END
)*0.0078125 ))
FROM sys.dm_db_partition_stats
WHERE object_id = s.object_id) as PESO_TABLA
from sys.tables s
where type_desc = 'USER_TABLE'
order by PESO_TABLA desc
~~~
# 


# Detectando actividad del servidor.<a name="dectectandoactenservidor"></a>
<img src="https://i.pinimg.com/originals/56/99/84/569984584af7d9c9224bd4a1a8ab7039.jpg?format=jpg&name=large" alt="JuveR" width="800">
# 


~~~sql
/*
Alejandro Jimenez   Agosto 01 2016
Determinación de la actividad del servidor

*/
SELECT es.session_id 
    ,DB_NAME(ES.database_id) DBNAME
    ,es.program_name 
    ,es.login_name 
    ,es.nt_user_name 
    ,es.login_time 
    ,es.host_name 
    ,es.cpu_time 
    ,es.total_scheduled_time 
    ,es.total_elapsed_time 
    ,es.memory_usage 
    ,es.logical_reads 
    ,es.reads 
    ,es.writes 
    ,st.text 
    --,es.database_id
    
FROM sys.dm_exec_sessions es 
    LEFT JOIN sys.dm_exec_connections ec  
        ON es.session_id = ec.session_id 
    LEFT JOIN sys.dm_exec_requests er 
        ON es.session_id = er.session_id 
    OUTER APPLY sys.dm_exec_sql_text (er.sql_handle) st 

    where                    es.session_id > 50    -- < 50 system sessions 
and login_time >'2019-09-11 01:00:00'
--ORDER BY es.cpu_time DESC 
ORDER BY login_time desc
~~~
# 

## Actividad del servidor para extraer en caso de que el servidor sea 2008 o menor
~~~sql


-- Eliminar la db temporal en caso que la misma ya exista
-- drop table db_temp
-- go

 
--Creacion de la base de datos db_temp para poder hacer el analisis de los datos
--y extraer lo que se requiere. 

--create table db_temp

--(

--SPID INT

--, Status varchar(50)

--,login varchar(50)

--,hostname varchar(50)

--,blkby varchar(50)

--,DBname varchar(50)

--,command varchar(500)

--,CPUTime int

--,DiskIO int

--,LastBatch varchar(15)

--,ProgramName varchar(500)

--,SPID2 INT

--,Requestid int

 

--)

 

 

 
--Ejecutar este comando y copiar en resultado en la tabla para poder ser analizado
--sp_who2
 

--Ejecutar este query para exytraer los datos solicitados.

SELECT [login]

      ,[hostname]

      ,[blkby]

      ,[DBname]


      ,MIN( [LastBatch]) "Fecha Minima"

      ,max( [LastBatch]) "Fecha Maxima"

      ,[ProgramName]


  FROM [master].[dbo].[db_temp]

 

  group by

        [login]

      ,[hostname]

      ,[blkby]

      ,[DBname]

      ,[ProgramName]

~~~




#
#### Nota este proceso fue creado por mi para enviar las actividades del serviro via correo electronico desde la base de datos Sql server en formatos HTML.
# 



~~~sql
USE [msdb]
GO
/****** Object:  StoredProcedure [dbo].[sp_EnviarActividad_Servidor10_0_0_252]   
 Script Date: 29/10/2020 03:51:55 p.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
NOTIFICACION
actividad del servidor del ultimo dia 
enviado por correo .
tenemos una tabla llamada notificacionesCorreos
 desde la misma controlamos las personas a las que se le enviara
  el reporte en html

 Alejandro Jimenez 
 2019-10-16
*/

ALTER procedure [dbo].[sp_EnviarActividad_Servidor10_0_0_252]
as

declare  @ActiviadadDelServidorTemp  table
(
       [DataBaseName] varchar(50)
      , [program_name] varchar(150)
      , [login_name] varchar(100)
      ,[nt_user_name] varchar(100)
      ,[login_time] datetime
      ,[host_name] varchar(50)
      ,[cpu_time] int
      ,[total_scheduled_time] int
      ,[total_elapsed_time] int
      ,[memory_usage] int 
      ,[logical_reads] int 
      ,[reads] int 
      ,[writes] int 
      )



insert into @ActiviadadDelServidorTemp
exec sp_ActiviadadDelServidorTemp

declare @email varchar(100) =
( SELECT 
      
      [correo]
      
  FROM  [AuditoriaDB].[dbo].[NotificacionesCorreos]
  WHERE ID =1002
  )

DECLARE @Body NVARCHAR(MAX),
    @TableHead VARCHAR(1000),
    @TableTail VARCHAR(1000)
    --,@dias int = 2
    ,@fecha varchar(10) = convert(varchar(10), getdate(),120)

SET @TableTail = '</table></body></html>' ;
SET @TableHead = '<html><head>' + '<style>'
    + 'td {border: solid black;border-width: 1px;padding-left:5px;padding-right:5px;padding-top:1px;padding-bottom:1px;font: 11px arial} '
    + '</style>' + '</head>' + '<body>' + '<h1>Reporte de Eventos en el Servidor 10.0.0.252 al dia : ' + @fecha +'  </h1> '
    + '<b>LogicalRead Mayor 100 || Write Mayor 0 || horas No laborables || No Usuarios de TRANSDOC</b>' 
    + '<br><b>Fecha y hora de envio: </b>'+ CONVERT(VARCHAR(50), GETDATE(), 100) 
    + ' <br> <table cellpadding=0 cellspacing=0 border=0>' 

    + '<tr> <td bgcolor=#E6E6FA><b>DataBaseName</b></td>'
    + '<td bgcolor=#E6E6FA><b>Program_Name</b></td>'
    + '<td bgcolor=#E6E6FA><b>login_Name</b></td>'
    + '<td bgcolor=#ffffb3><b>nt_user_name</b></td>'
    + '<td bgcolor=#E6E6FA><b>Login_Time</b></td>'
    + '<td bgcolor=#E6E6FA><b>Host_Name</b></td>'
    + '<td bgcolor=#E6E6FA><b>Cpu_Time</b></td>'
    + '<td bgcolor=#E6E6FA><b>Total_Scheduled_Time</b></td>'
    + '<td bgcolor=#E6E6FA><b>Total_Elapsed_Time</b></td>'
    + '<td bgcolor=#E6E6FA><b>Logical_Reads</b></td>'
    + '<td bgcolor=#E6E6FA><b>Reads</b></td>'
    + '<td bgcolor=#E6E6FA><b>Writes</b></td></tr>' ;

SET @Body = (

SELECT 
       td = [DataBaseName] , ''
      ,td =  [program_name] , ''
      ,td = [login_name], ''
      ,td = [nt_user_name], ''
      ,td =  [login_time], ''
      ,td  =  [host_name], ''
      ,td = [cpu_time], ''
      ,td = [total_scheduled_time], ''
      ,td = [total_elapsed_time], ''
      ,td = [logical_reads], ''
      ,td = [reads], ''
      ,td = [writes], ''
  FROM @ActiviadadDelServidorTemp
  order by login_time desc
            FOR   XML RAW('tr'),
                  ELEMENTS
            )


SELECT  @Body = @TableHead + ISNULL(@Body, '') + @TableTail

/*
Enviar Correo electronico 
alejandro Jimenez 
2019-10-16 
*/
EXEC sp_send_dbmail 
  @profile_name='SqlMail',
  @copy_recipients ='jose.jimenez@INABIMA.GOB.DO',
  @recipients=  @email,  --'jose.jimenez@INABIMA.GOB.DO', --; ja.jimenezrosa@gmail.com',
  @subject='Monitoreo de instancias y Bases de Datos SQL Server 10.0.0.252',
  @body=@Body ,
  @body_format = 'HTML' ;
~~~

# 


## Este query es una consulta SQL que se utiliza para recopilar información sobre las sesiones en una instancia de SQL Server en tiempo real. Proporciona información detallada sobre las sesiones en ejecución, sus consultas, bloqueos, y más. Aquí está una descripción de las partes clave de este query:<a name="20.1"></a>

1. `SELECT`: Esta es la cláusula de selección que define las columnas que se mostrarán en los resultados de la consulta.

2. Lista de columnas seleccionadas: Cada columna en la lista representa un atributo específico que se recopilará para cada sesión en ejecución. Algunos ejemplos de las columnas seleccionadas incluyen `session_id`, `status`, `login_name`, `database_name`, `host_name`, `program_name`, `blocking_session_id`, `command`, `reads`, `writes`, `cpu_time`, `wait_type`, `wait_time`, `last_wait_type`, `wait_resource`, `transaction_isolation_level`, `object_name`, `query_text`, y `query_plan`.

3. `FROM`: Esta cláusula especifica las tablas y vistas de las que se extraerán los datos. El query utiliza múltiples tablas del sistema, incluyendo `sys.dm_exec_connections`, `sys.dm_exec_sessions`, `sys.dm_exec_requests`, `sys.dm_exec_sql_text`, y `sys.dm_exec_query_plan`.

4. `OUTER JOIN`: Se utilizan uniones externas para combinar los datos de diferentes tablas, asegurando que se incluyan todas las sesiones en ejecución y que los datos se muestren incluso si no hay correspondencias en todas las tablas.

5. `WHERE`: La cláusula WHERE establece condiciones de filtrado para limitar los resultados a sesiones en ejecución que cumplan con ciertos criterios. Por ejemplo, excluye la sesión actual (`@@SPID`) y solo muestra las sesiones con un estado de 'running'.

6. `ORDER BY`: La cláusula ORDER BY especifica el orden en el que se presentarán los resultados. En este caso, las sesiones se ordenan por su identificador de sesión (`session_id`).

#### En resumen, este query recopila información sobre las sesiones en ejecución en una instancia de SQL Server, incluyendo detalles como el estado de la sesión, el nombre de inicio de sesión, la base de datos en uso, el host y programa desde el que se conecta, la consulta actual, el tiempo de CPU, el tipo de espera, los recursos de espera, el nivel de aislamiento de transacción, y otros atributos relevantes. Esta información es útil para monitorear y diagnosticar el rendimiento de la base de datos y las sesiones activas en SQL Server.

~~~sql
 SELECT

              es.session_id

              ,es.status

              ,es.login_name

              ,DB_NAME(er.database_id) as database_name

              ,es.host_name

              ,es.program_name

              ,er.blocking_session_id

              ,er.command

              ,es.reads

              ,es.writes

              ,es.cpu_time

              ,er.wait_type

              ,er.wait_time

              ,er.last_wait_type

              ,er.wait_resource

              ,CASE es.transaction_isolation_level WHEN 0 THEN 'Unspecified'

              WHEN 1 THEN 'ReadUncommitted'

              WHEN 2 THEN 'ReadCommitted'

              WHEN 3 THEN 'Repeatable'

              WHEN 4 THEN 'Serializable'

              WHEN 5 THEN 'Snapshot'

              END AS transaction_isolation_level

              ,OBJECT_NAME(st.objectid, er.database_id) as object_name

              ,SUBSTRING(st.text, er.statement_start_offset / 2,

              (CASE WHEN er.statement_end_offset = -1 THEN LEN(CONVERT(nvarchar(max), st.text)) * 2

              ELSE er.statement_end_offset END - er.statement_start_offset) / 2) AS query_text

              ,ph.query_plan

              FROM sys.dm_exec_connections ec

              LEFT OUTER JOIN sys.dm_exec_sessions es ON ec.session_id = es.session_id

              LEFT OUTER JOIN sys.dm_exec_requests er ON ec.connection_id = er.connection_id

              OUTER APPLY sys.dm_exec_sql_text(sql_handle) st

              OUTER APPLY sys.dm_exec_query_plan(plan_handle) ph

              WHERE ec.session_id  <> @@SPID

              AND es.status = 'running'

ORDER BY es.session_id;
~~~


# 




# Cuantos Core Tiene mi base de datos<a name="cuantoscoretengo"></a>
# 
<img src="https://hardzone.es/app/uploads/2019/07/Sistema-01.jpg?format=jpg&name=large" alt="JuveR" width="800px">
# 

~~~sql
select scheduler_id, cpu_id, status, is_online 
from sys.dm_os_schedulers 
where status = 'VISIBLE ONLINE'
go

xp_cmdshell 'WMIC CPU Get DeviceID,NumberOfCores,NumberOfLogicalProcessors'
go
~~~

# 


#

# USUARIOS<a name="usuarios"></a>
![](https://www.osi.es/sites/default/files/images/imagen-decorativa-infografia-cuentas-usuario.png)
# Query de los usuarios y sus roles en una Base de Datos
# 


~~~sql

/*Querys that display the users and Roles from Sql server 2012.


I make this Query in order of an Store Procedure tha appears on
 TRANSDOC Database on june 22 2016
It is not supose to be there , Bbut aparently the sistem need to 
have a owner database user, in order to proces his will
*/
SELECT
  p.name rol,
  p.principal_id id_rol,
  m.name usuario,
  m.principal_id id_usuario
FROM sys.database_role_members rm
  INNER JOIN sys.database_principals p
    ON rm.role_principal_id = p.principal_id
  INNER JOIN sys.database_principals m
    ON rm.member_principal_id = m.principal_id
ORDER BY p.name

/*Query de olos usuarios y sus Rol ID*/
SELECT a.name, a.type_desc, a.is_disabled , a.principal_id
FROM sys.server_principals a
WHERE type_desc IN('SQL_LOGIN', 'WINDOWS_LOGIN', 'WINDOWS_GROUP');
~~~
# 



## Query de listado de Tablas con su Tamano y su cantidad de registros<a name="listadotablas"></a>

<div>
<p style = 'text-align:center;'>
<img src="https://desarrolloweb.com/media/696/campos-tablas.jpg?format=jpg&name=small" alt="JuveYell" width="750px">
</p>
</div>

#### En el query proporcionado para SQL Server, la columna size_bytes representa el tamaño total de la tabla en bytes. La unidad de medida en este caso es bytes. Si deseas expresar el tamaño en kilobytes (KB), megabytes (MB), gigabytes (GB) u otra unidad más conveniente, puedes realizar la conversión correspondiente.

#### Aquí tienes algunas conversiones comunes:

###### KB: size_bytes / 1024
###### MB: size_bytes / (1024 * 1024)
###### GB: size_bytes / (1024 * 1024 * 1024)
#### Puedes ajustar el resultado según la unidad de medida que prefieras. Por ejemplo, si deseas obtener el tamaño en megabytes, la consulta podría modificarse así:

~~~sql
SELECT 
    t.name AS table_name,
    p.rows AS cantidad_registros,
    SUM(a.total_pages) * 8 / (1024 * 1024) AS size_mb
FROM 
    sys.tables t
INNER JOIN      
    sys.indexes i ON t.object_id = i.object_id
INNER JOIN 
    sys.partitions p ON i.object_id = p.object_id AND i.index_id = p.index_id
INNER JOIN 
    sys.allocation_units a ON p.partition_id = a.container_id
WHERE 
    t.is_ms_shipped = 0
GROUP BY 
    t.name, p.rows
ORDER BY 
    table_name;

~~~

#### Esta modificación divide el tamaño total en bytes por (1024 * 1024) para obtener el tamaño en megabytes. Puedes ajustar la división según la unidad de medida que prefieras utilizar.


# 

### **Query para Monitorear Sesiones Activas y Consultas en Ejecución en SQL Server**<a name="7.11"></a>


#### **Descripción**
Este script proporciona una visión detallada de las sesiones activas en un servidor SQL Server, incluyendo información sobre las consultas en ejecución, la base de datos involucrada, el plan de ejecución y otros detalles relacionados con el rendimiento y bloqueo de transacciones. Es útil para administradores de bases de datos que necesitan diagnosticar problemas de rendimiento, identificar consultas bloqueadas o analizar patrones de uso.

---

#### **Código**

```sql
SELECT 
    es.session_id,
    es.status,
    es.login_name,
    DB_NAME(er.database_id) AS database_name,
    es.host_name,
    es.program_name,
    er.blocking_session_id,
    er.command,
    es.reads,
    es.writes,
    es.cpu_time,
    er.wait_type,
    er.wait_time,
    er.last_wait_type,
    er.wait_resource,
    CASE es.transaction_isolation_level 
        WHEN 0 THEN 'Unspecified'
        WHEN 1 THEN 'ReadUncommitted'
        WHEN 2 THEN 'ReadCommitted'
        WHEN 3 THEN 'Repeatable'
        WHEN 4 THEN 'Serializable'
        WHEN 5 THEN 'Snapshot'
    END AS transaction_isolation_level,
    OBJECT_NAME(st.objectid, er.database_id) AS object_name,
    SUBSTRING(st.text, er.statement_start_offset / 2,
        (CASE 
            WHEN er.statement_end_offset = -1 
                THEN LEN(CONVERT(nvarchar(max), st.text)) * 2
            ELSE er.statement_end_offset 
         END - er.statement_start_offset) / 2) AS query_text,
    ph.query_plan
FROM sys.dm_exec_connections ec
LEFT OUTER JOIN sys.dm_exec_sessions es ON ec.session_id = es.session_id
LEFT OUTER JOIN sys.dm_exec_requests er ON ec.connection_id = er.connection_id
OUTER APPLY sys.dm_exec_sql_text(sql_handle) st
OUTER APPLY sys.dm_exec_query_plan(plan_handle) ph
WHERE ec.session_id <> @@SPID
  AND es.status = 'running'
ORDER BY es.session_id;
```

---

#### **Columnas del Resultado**

1. **`session_id`**: Identificador único de la sesión en SQL Server.
2. **`status`**: Estado actual de la sesión (en este caso, filtra las sesiones en estado `running`).
3. **`login_name`**: Usuario que inició sesión en SQL Server.
4. **`database_name`**: Nombre de la base de datos a la que está asociada la sesión.
5. **`host_name`**: Nombre del host desde el cual se inició la sesión.
6. **`program_name`**: Programa cliente que inició la conexión.
7. **`blocking_session_id`**: Identificador de la sesión que está bloqueando a esta sesión, si aplica.
8. **`command`**: Comando SQL actual que se está ejecutando.
9. **`reads`**: Número de lecturas lógicas realizadas por la sesión.
10. **`writes`**: Número de escrituras realizadas por la sesión.
11. **`cpu_time`**: Tiempo de CPU consumido por la sesión, medido en milisegundos.
12. **`wait_type`**: Tipo actual de espera de la sesión (si aplica).
13. **`wait_time`**: Tiempo que la sesión ha estado en espera (en milisegundos).
14. **`last_wait_type`**: Último tipo de espera registrado.
15. **`wait_resource`**: Recurso que está causando la espera.
16. **`transaction_isolation_level`**: Nivel de aislamiento de la transacción para la sesión.
17. **`object_name`**: Nombre del objeto (tabla, vista, procedimiento almacenado) involucrado en la consulta.
18. **`query_text`**: Texto SQL de la consulta actualmente en ejecución.
19. **`query_plan`**: Plan de ejecución estimado de la consulta.

---

#### **Uso Práctico**
Este query es ideal para:

1. **Identificar bloqueos**: Revisar sesiones bloqueadas o que están bloqueando otras.
2. **Diagnóstico de consultas lentas**: Analizar las consultas en ejecución que consumen muchos recursos.
3. **Revisión de patrones de uso**: Entender qué aplicaciones, usuarios o programas están accediendo al servidor.
4. **Optimización**: Inspeccionar el plan de ejecución para mejorar consultas SQL.

---

#### **Nota**
Ejecute este query con permisos de administrador o con acceso a las vistas dinámicas del sistema. Usar este tipo de consultas en entornos de producción debe ser controlado, especialmente en sistemas con alta carga, ya que puede introducir alguna latencia en la recolección de datos.


---
# Script de Monitoreo y Optimización del Rendimiento de SQL Server<a name="500"></a>

## DESCARGO DE RESPONSABILIDAD
El código de muestra se proporciona con fines ilustrativos y no está destinado a ser utilizado en un entorno de producción. Este código de muestra y cualquier información relacionada se proporcionan "tal cual" sin garantía de ningún tipo, ya sea expresa o implícita, incluidas, entre otras, las garantías implícitas de comerciabilidad y/o aptitud para un propósito particular. Le otorgamos un derecho no exclusivo y libre de regalías para usar y modificar el código de muestra y para reproducir y distribuir la forma de código objeto del código de muestra, siempre que:

1. Usted acepta no usar nuestro nombre, logotipo o marcas comerciales para comercializar su producto de software en el que se incrusta el código de muestra.
2. Incluye un aviso de derechos de autor válido en su producto de software en el que se incrusta el código de muestra.
3. Usted indemniza, libera de responsabilidad y defiende a nosotros y a nuestros proveedores de cualquier reclamo o demanda, incluidos honorarios de abogados, que surjan o resulten del uso o distribución del código de muestra.

## Propósito
Este script SQL proporciona un conjunto completo de consultas para monitorear y optimizar el rendimiento de una base de datos de SQL Server. Incluye varias secciones como información del servidor, procesos de bloqueo, estadísticas de espera, estadísticas de latch, información de memoria, utilización de archivos de base de datos de E/S, consultas más costosas, índices faltantes y declaraciones de creación de índices.

## Cómo Usar
1. Ejecute cada sección del script secuencialmente en una ventana de consulta de SQL Server Management Studio (SSMS).
2. Revise la salida de cada sección para comprender el rendimiento del servidor e identificar áreas de optimización.
3. Personalice el script según sea necesario para su entorno de base de datos específico.
4. Asegúrese de que se otorguen los permisos adecuados para ejecutar estas consultas.

## Componentes
- **Información del Servidor**: Proporciona información básica sobre la instancia de SQL Server, como el nombre del servidor, la versión del producto, la edición, etc.
- **Procesos de Bloqueo**: Identifica cualquier proceso que esté bloqueando actualmente o que esté siendo bloqueado por otros procesos.
- **Información de Esperas**: Analiza las estadísticas de espera para identificar las fuentes más significativas de espera dentro de la base de datos.
- **Latches**: Proporciona estadísticas de latch para comprender la contención de recursos de latch.
- **Tareas en Espera**: Enumera las tareas que están esperando recursos o están bloqueadas actualmente.
- **Información de Memoria**: Muestra información sobre el uso y los límites de memoria.
- **Utilización y Latencia de Archivos de Base de Datos de E/S**: Analiza el rendimiento de E/S para archivos de base de datos.
- **Top 10 de Consultas Más Costosas**: Identifica las principales consultas que consumen recursos de CPU y disco.
- **Índices Faltantes**: Sugiere mejoras potenciales de índice según las estadísticas de ejecución de consultas.
- **Declaración de Creación de Índices Faltantes**: Genera declaraciones CREATE INDEX para los índices faltantes sugeridos.

## Descargo de Responsabilidad
Este script está destinado únicamente con fines educativos y debe usarse con precaución en un entorno de producción. Siempre revise y pruebe los scripts a fondo antes de aplicarlos a un sistema de producción.

~~~sql
/*DISCLAIMER. Sample Code is provided for the purpose of illustration only and is not intended to be used in a production environment. 
THIS SAMPLE CODE AND ANY RELATED INFORMATION ARE PROVIDED "AS IS" WITHOUT WARRANTY OF ANY KIND, EITHER EXPRESSED OR IMPLIED, 
INCLUDING BUT NOT LIMITED TO THE IMPLIED WARRANTIES OF MERCHANTABILITY AND/OR FITNESS FOR A PARTICULAR PURPOSE. 
We grant you a nonexclusive, royalty-free right to use and modify the Sample Code and to reproduce and distribute the object code form of the Sample Code, provided that. You agree: 
(i) to not use Our name, logo, or trademarks to market Your software product in which the Sample Code is embedded; 
(ii) to include a valid copyright notice on Your software product in which the Sample Code is embedded; and 
(iii) to indemnify, hold harmless, and defend Us and Our suppliers from and against any claims or lawsuits, including attorneys' fees, that arise or result from the use or distribution of the Sample Code.*/
--------------------------------------------------------------------------------------------------------------------------
SELECT @@SERVERNAME
GO
SELECT SERVERPROPERTY('productversion'), SERVERPROPERTY ('productlevel'), SERVERPROPERTY ('edition')
GO

--------------------------------------------------------------------------------------------------------------------------

SELECT session_id ,status ,command, blocking_session_id
    ,wait_type ,wait_time ,wait_resource 
    ,transaction_id, estimated_completion_time
FROM sys.dm_exec_requests 
WHERE (status = N'suspended' OR status = N'running')
AND session_id <> @@SPID;
GO

----------------------------------------------------Blocking Processes----------------------------------------------------

--Parte 1
SELECT
             WaitingTime = s.waittime, s.spid, BlockingSPID = s.blocked, DatabaseName = DB_NAME(s.dbid),
             s.program_name, s.loginame, s.hostname, s.cmd, ObjectName = OBJECT_NAME(objectid,s.dbid), Definition = CAST(text AS VARCHAR(MAX))
 INTO        #Processes
 FROM      sys.sysprocesses s
 CROSS APPLY sys.dm_exec_sql_text (sql_handle)
 WHERE
            s.spid > 50
go            

--select * from #Processes
--Parte2

WITH Blocking(SPID, BlockingSPID, "WaitingTime (secs)", BlockingStatement, LoginName, HostName, Command, RowNo, LevelRow)
 AS
 (
      SELECT
       s.spid, s.BlockingSPID, s.WaitingTime/1000, s.Definition, s.loginame, s.hostname, s.cmd,
       ROW_NUMBER() OVER(ORDER BY s.spid),
       0 AS LevelRow
     FROM
       #Processes s
       JOIN #Processes s1 ON s.spid = s1.BlockingSPID
     WHERE
       s.BlockingSPID = 0
     UNION ALL
     SELECT
       r.spid,  r.BlockingSPID, r.WaitingTime/1000, r.Definition, r.loginame, r.hostname, r.cmd,
       d.RowNo,
       d.LevelRow + 1
     FROM
       #Processes r
      JOIN Blocking d ON r.BlockingSPID = d.SPID
     WHERE
       r.BlockingSPID > 0
 )
 SELECT * FROM Blocking
 ORDER BY RowNo, LevelRow
 go

--Parte 3
 drop table #Processes
 go
 --------------------------------------------------------Waits Info--------------------------------------------------

WITH [Waits] AS
    (SELECT
        [wait_type],
        [wait_time_ms] / 1000.0 AS [WaitS],
        ([wait_time_ms] - [signal_wait_time_ms]) / 1000.0 AS [ResourceS],
        [signal_wait_time_ms] / 1000.0 AS [SignalS],
        [waiting_tasks_count] AS [WaitCount],
        100.0 * [wait_time_ms] / SUM ([wait_time_ms]) OVER() AS [Percentage],
        ROW_NUMBER() OVER(ORDER BY [wait_time_ms] DESC) AS [RowNum]
    FROM sys.dm_os_wait_stats
    WHERE [wait_type] NOT IN (
        N'BROKER_EVENTHANDLER',             N'BROKER_RECEIVE_WAITFOR',
        N'BROKER_TASK_STOP',                N'BROKER_TO_FLUSH',
        N'BROKER_TRANSMITTER',              N'CHECKPOINT_QUEUE',
        N'CHKPT',                           N'CLR_AUTO_EVENT',
        N'CLR_MANUAL_EVENT',                N'CLR_SEMAPHORE',
        N'DBMIRROR_DBM_EVENT',              N'DBMIRROR_EVENTS_QUEUE',
        N'DBMIRROR_WORKER_QUEUE',           N'DBMIRRORING_CMD',
        N'DIRTY_PAGE_POLL',                 N'DISPATCHER_QUEUE_SEMAPHORE',
        N'EXECSYNC',                        N'FSAGENT',
        N'FT_IFTS_SCHEDULER_IDLE_WAIT',     N'FT_IFTSHC_MUTEX',
        N'HADR_CLUSAPI_CALL',               N'HADR_FILESTREAM_IOMGR_IOCOMPLETION',
        N'HADR_LOGCAPTURE_WAIT',            N'HADR_NOTIFICATION_DEQUEUE',
        N'HADR_TIMER_TASK',                 N'HADR_WORK_QUEUE',
        N'KSOURCE_WAKEUP',                  N'LAZYWRITER_SLEEP',
        N'LOGMGR_QUEUE',                    N'ONDEMAND_TASK_QUEUE',
        N'PWAIT_ALL_COMPONENTS_INITIALIZED',
        N'QDS_PERSIST_TASK_MAIN_LOOP_SLEEP',
        N'QDS_CLEANUP_STALE_QUERIES_TASK_MAIN_LOOP_SLEEP',
        N'REQUEST_FOR_DEADLOCK_SEARCH',     N'RESOURCE_QUEUE',
        N'SERVER_IDLE_CHECK',               N'SLEEP_BPOOL_FLUSH',
        N'SLEEP_DBSTARTUP',                 N'SLEEP_DCOMSTARTUP',
        N'SLEEP_MASTERDBREADY',             N'SLEEP_MASTERMDREADY',
        N'SLEEP_MASTERUPGRADED',            N'SLEEP_MSDBSTARTUP',
        N'SLEEP_SYSTEMTASK',                N'SLEEP_TASK',
        N'SLEEP_TEMPDBSTARTUP',             N'SNI_HTTP_ACCEPT',
        N'SP_SERVER_DIAGNOSTICS_SLEEP',     N'SQLTRACE_BUFFER_FLUSH',
        N'SQLTRACE_INCREMENTAL_FLUSH_SLEEP',
        N'SQLTRACE_WAIT_ENTRIES',           N'WAIT_FOR_RESULTS',
        N'WAITFOR',                         N'WAITFOR_TASKSHUTDOWN',
        N'WAIT_XTP_HOST_WAIT',              N'WAIT_XTP_OFFLINE_CKPT_NEW_LOG',
        N'WAIT_XTP_CKPT_CLOSE',             N'XE_DISPATCHER_JOIN',
        N'XE_DISPATCHER_WAIT',              N'XE_TIMER_EVENT')
    AND [waiting_tasks_count] > 0
 )
SELECT
    TOP 5
    MAX ([W1].[wait_type]) AS [WaitType],
    CAST (MAX ([W1].[WaitS]) AS DECIMAL (16,2)) AS [Wait_S],
    CAST (MAX ([W1].[ResourceS]) AS DECIMAL (16,2)) AS [Resource_S],
    CAST (MAX ([W1].[SignalS]) AS DECIMAL (16,2)) AS [Signal_S],
    MAX ([W1].[WaitCount]) AS [WaitCount],
    CAST (MAX ([W1].[Percentage]) AS DECIMAL (5,2)) AS [Percentage],
    CAST ((MAX ([W1].[WaitS]) / MAX ([W1].[WaitCount])) AS DECIMAL (16,4)) AS [AvgWait_S],
    CAST ((MAX ([W1].[ResourceS]) / MAX ([W1].[WaitCount])) AS DECIMAL (16,4)) AS [AvgRes_S],
    CAST ((MAX ([W1].[SignalS]) / MAX ([W1].[WaitCount])) AS DECIMAL (16,4)) AS [AvgSig_S]
FROM [Waits] AS [W1]
INNER JOIN [Waits] AS [W2]
    ON [W2].[RowNum] <= [W1].[RowNum]
GROUP BY [W1].[RowNum]
HAVING SUM ([W2].[Percentage]) - MAX ([W1].[Percentage]) < 95; -- percentage threshold
GO

-------------------------------------------------------------Latches-----------------------------------------------------

WITH [Latches] AS
    (SELECT
        [latch_class],
        [wait_time_ms] / 1000.0 AS [WaitS],
        [waiting_requests_count] AS [WaitCount],
        100.0 * [wait_time_ms] / SUM ([wait_time_ms]) OVER() AS [Percentage],
        ROW_NUMBER() OVER(ORDER BY [wait_time_ms] DESC) AS [RowNum]
    FROM sys.dm_os_latch_stats
    WHERE [latch_class] NOT IN (
        N'BUFFER')
    AND [wait_time_ms] > 0
)
SELECT
    MAX ([W1].[latch_class]) AS [LatchClass],
    CAST (MAX ([W1].[WaitS]) AS DECIMAL(14, 2)) AS [Wait_S],
    MAX ([W1].[WaitCount]) AS [WaitCount],
    CAST (MAX ([W1].[Percentage]) AS DECIMAL(14, 2)) AS [Percentage],
    CAST ((MAX ([W1].[WaitS]) / MAX ([W1].[WaitCount])) AS DECIMAL (14, 4)) AS [AvgWait_S]
FROM [Latches] AS [W1]
INNER JOIN [Latches] AS [W2]
    ON [W2].[RowNum] <= [W1].[RowNum]
GROUP BY [W1].[RowNum]
HAVING SUM ([W2].[Percentage]) - MAX ([W1].[Percentage]) < 95; -- percentage threshold
GO

-------------------------------------------------------------Waiting Tasks-------------------------------------------------

SELECT 'Waiting_tasks' AS [Information], owt.session_id,
     owt.wait_duration_ms,
     owt.wait_type,
     owt.blocking_session_id,
     owt.resource_description,
     es.program_name,
     est.text,
     est.dbid,
     eqp.query_plan,
     er.database_id,
     es.cpu_time,
     es.memory_usage
 FROM sys.dm_os_waiting_tasks owt
 INNER JOIN sys.dm_exec_sessions es ON owt.session_id = es.session_id
 INNER JOIN sys.dm_exec_requests er ON es.session_id = er.session_id
 OUTER APPLY sys.dm_exec_sql_text (er.sql_handle) est
 OUTER APPLY sys.dm_exec_query_plan (er.plan_handle) eqp
 WHERE es.is_user_process = 1
 AND owt.wait_duration_ms > 0;
 GO
 
--------------------------------------------------------Memory Info--------------------------------------------------
 SELECT
(physical_memory_in_use_kb/1024)/1024 AS 'Physical Memory in Use (GB)',
(total_virtual_address_space_kb/1024)/1024 AS 'Total Virtual Address Space (GB)',
(virtual_address_space_committed_kb/1024)/1024 AS 'Total Virtual Address Space Committed (GB)',
(virtual_address_space_available_kb/1024)/1024 AS 'Total Virtual Address Space Available (GB)'
FROM sys.dm_os_process_memory
GO

SELECT 
(physical_memory_kb/1024)/1024 AS 'Physical Memory (GB)', 
(committed_kb/1024)/1024 AS 'Committed Memory (GB)' 
FROM sys.dm_os_sys_info 
GO

SELECT 
counter_name AS 'Performance Counter', 
cntr_value AS 'Counter Value' 
FROM sys.dm_os_performance_counters
WHERE counter_name in  ('Lock Memory (KB)', 'Target Server Memory (KB)', 'Total Server Memory (KB)', 'Buffer Cache Hit Ratio', 'Page life expectancy', 'DatabASe Pages')
GROUP BY counter_name,cntr_value
GO

SELECT memory_limit_mb, process_memory_limit_mb
FROM sys.dm_os_job_object

-------------------------------------------------I/O Database File Utilization And Latency-----------------------------------

SELECT TOP 5 DB_NAME(a.database_id) AS [Database Name] , b.type_desc, b.physical_name, CAST(( io_stall_read_ms + io_stall_write_ms ) / ( 1.0 + num_of_reads + num_of_writes) AS NUMERIC(10,1)) AS [avg_io_stall_ms]
FROM sys.dm_io_virtual_file_stats(NULL, NULL) a
INNER JOIN sys.master_files b 
ON a.database_id = b.database_id and a.file_id = b.file_id
ORDER BY avg_io_stall_ms DESC ;
GO

SELECT DB_NAME(f.database_id) AS database_name, f.name AS logical_file_name, f.type_desc, 
    CAST (CASE 
        -- Handle UNC paths (e.g. '\\fileserver\readonlydbs\dept_dw.ndf')
        WHEN LEFT (LTRIM (f.physical_name), 2) = '\\' 
            THEN LEFT (LTRIM (f.physical_name),CHARINDEX('\',LTRIM(f.physical_name),CHARINDEX('\',LTRIM(f.physical_name), 3) + 1) - 1)
            -- Handle local paths (e.g. 'C:\Program Files\...\master.mdf') 
            WHEN CHARINDEX('\', LTRIM(f.physical_name), 3) > 0 
            THEN UPPER(LEFT(LTRIM(f.physical_name), CHARINDEX ('\', LTRIM(f.physical_name), 3) - 1))
        ELSE f.physical_name
    END AS NVARCHAR(255)) AS logical_disk,
    fs.size_on_disk_bytes/1024/1024 AS size_on_disk_Mbytes,
    fs.num_of_reads, fs.num_of_writes,
    fs.num_of_bytes_read/1024/1024 AS num_of_Mbytes_read,
    fs.num_of_bytes_written/1024/1024 AS num_of_Mbytes_written,
    (fs.io_stall_read_ms / (1.0 + fs.num_of_reads)) AS avg_read_latency_ms,
    (fs.io_stall_write_ms / (1.0 + fs.num_of_writes)) AS avg_write_latency_ms
FROM sys.dm_io_virtual_file_stats (default, default) AS fs
INNER JOIN sys.master_files AS f ON fs.database_id = f.database_id AND fs.[file_id] = f.[file_id]
ORDER BY 2 DESC
GO

-------------------------------------------------Top 10 most expensive queries-----------------------------------------------

SELECT TOP 10 
        (SELECT db_name(dbid) FROM sys.dm_exec_sql_text(qs.plan_handle)) DBName, 
        (SELECT object_name(objectid, dbid) FROM sys.dm_exec_sql_text(qs.plan_handle)) 		AS SPName, 
        (SELECT SUBSTRING(text, statement_start_offset/2 + 1, (CASE WHEN 			statement_end_offset = -1 THEN LEN(CONVERT(nvarchar(max), text)) * 2 ELSE 		statement_end_offset END - statement_start_offset)/2) FROM 			sys.dm_exec_sql_text(sql_handle)) AS query_text,
        creation_time,
        last_execution_time,
        execution_count,
        total_worker_time / 1000 AS CPU_ms,
        total_worker_time / execution_count / 1000 AS Avg_CPU_ms,
        total_logical_reads AS page_reads,
        total_logical_reads / execution_count AS Avg_page_reads,
        total_elapsed_time / 1000 AS CPU_ms,
        total_worker_time / execution_count / 1000 AS Avg_CPU_ms,
        (SELECT query_plan FROM sys.dm_exec_query_plan(qs.plan_handle)) QueryPlan
FROM sys.dm_exec_query_stats qs
ORDER BY total_worker_time DESC
go

------------------------------------------------------Missing Indexes--------------------------------------------------------

SELECT TOP 5 priority = avg_total_user_cost * avg_user_impact * (user_seeks + user_scans) , 
d.statement , d.equality_columns , d.inequality_columns , d.included_columns , 
s.avg_total_user_cost , s.avg_user_impact , s.user_seeks, s.user_scans 
FROM sys.dm_db_missing_index_group_stats s 
JOIN sys.dm_db_missing_index_groups g 
ON s.group_handle = g.index_group_handle 
JOIN sys.dm_db_missing_index_details d 
ON g.index_handle = d.index_handle 
ORDER BY priority DESC
go

---------------------------------------------Missing Indexes Creation Statement----------------------------------------------


;WITH I AS ( 
SELECT --user_seeks * avg_total_user_cost * (avg_user_impact * 0.01) AS [index_advantage], 
        avg_total_user_cost * avg_user_impact * (user_seeks + user_scans) AS [Priority],
migs.last_user_seek, 
mid.[statement] AS [Database.Schema.Table], 
mid.equality_columns, mid.inequality_columns, 
mid.included_columns,migs.unique_compiles, migs.user_seeks, 
migs.avg_total_user_cost, migs.avg_user_impact 
FROM sys.dm_db_missing_index_group_stats AS migs WITH (NOLOCK) 
INNER JOIN sys.dm_db_missing_index_groups AS mig WITH (NOLOCK) 
ON migs.group_handle = mig.index_group_handle 
INNER JOIN sys.dm_db_missing_index_details AS mid WITH (NOLOCK) 
ON mig.index_handle = mid.index_handle 
--WHERE mid.database_id = db_id('driveatv') --DB_ID() 
      --AND user_seeks * avg_total_user_cost * (avg_user_impact * 0.01) > 90 -- Set this to Whatever 
    
) 
SELECT top 5 'CREATE INDEX IX_' 
            + SUBSTRING([Database.Schema.Table], 
                              CHARINDEX('].[',[Database.Schema.Table], 
                              CHARINDEX('].[',[Database.Schema.Table])+4)+3, 
                              LEN([Database.Schema.Table]) -   
                              (CHARINDEX('].[',[Database.Schema.Table], 
                              CHARINDEX('].[',[Database.Schema.Table])+4)+3)) 
            + '_' + LEFT(REPLACE(REPLACE(REPLACE(REPLACE( 
            ISNULL(equality_columns,inequality_columns), 
            '[',''),']',''),' ',''),',',''),20) 
            + ' ON ' 
            + [Database.Schema.Table] 
            + '(' 
            + ISNULL(equality_columns,'') 
            + CASE WHEN equality_columns IS NOT NULL AND 
                              inequality_columns IS NOT NULL 
                  THEN ',' 
                  ELSE '' 
              END 
      + ISNULL(inequality_columns,'') 
                 + ')' 
                 + CASE WHEN included_columns IS NOT NULL 
                  THEN ' INCLUDE(' + included_columns + ')' + ' WITH (ONLINE = ON)'
                  ELSE ' WITH (ONLINE = ON)'
              END CreateStatement
FROM I
order by Priority DESC
go
~~~


# 


# Buscar Caracteres Especiales en una Tabla de SQL Server<a name="7.12"></a>

Este script permite generar dinámicamente una consulta que valida si las columnas de una tabla específica contienen caracteres especiales. La validación incluye varios tipos de datos como `char`, `varchar`, `nchar`, `nvarchar`, `text`, `ntext`, `int`, `decimal`, `float`, y `datetime`.

## Propósito

El propósito de este script es automatizar la validación de datos en una tabla, asegurando que los valores en cada columna cumplan con un formato esperado, como ausencia de caracteres especiales.

## Instrucciones

### 1. Configuración del Script

1. Cambia el nombre de la tabla en la variable `@tableName` por el de la tabla que deseas analizar:
    ```sql
    DECLARE @tableName NVARCHAR(MAX) = 'nombre_de_tu_tabla';
    ```
2. Asegúrate de que la tabla exista en la base de datos actual y contenga columnas con los tipos de datos soportados.

### 2. Tipos de Datos Soportados

El script considera las columnas con los siguientes tipos de datos:
- `char`
- `varchar`
- `nchar`
- `nvarchar`
- `text`
- `ntext`
- `int`
- `decimal`
- `float`
- `datetime`

Puedes modificar esta lista ajustando la cláusula `DATA_TYPE IN` dentro del script.

### 3. Ejecución del Script

Ejecuta el script completo en tu entorno de SQL Server. El script realiza los siguientes pasos:

1. Construye dinámicamente una consulta para analizar cada columna de la tabla.
2. Verifica si los valores en cada columna contienen caracteres especiales.
3. Genera un resultado indicando si cada campo tiene caracteres especiales o no.

### 4. Salida

La salida es una tabla con las siguientes columnas:
- **Campo**: Nombre de la columna analizada.
- **Validación**: Resultado indicando si la columna contiene caracteres especiales (`Contiene caracteres especiales`) o no (`No contiene caracteres especiales`).

## Código

```sql
DECLARE @sql NVARCHAR(MAX) = '';
DECLARE @tableName NVARCHAR(MAX) = 'diskdetails'; -- Cambia por el nombre de tu tabla

-- Construye dinámicamente la consulta
SELECT @sql += 
    'SELECT ''' + COLUMN_NAME + ''' AS Campo, ' +
    'CASE ' +
    'WHEN TRY_CAST([' + COLUMN_NAME + '] AS NVARCHAR(MAX)) LIKE ''%[^a-zA-Z0-9]%'' ' +
    'THEN ''Contiene caracteres especiales'' ' +
    'ELSE ''No contiene caracteres especiales'' END AS Validación ' +
    'FROM [' + @tableName + '] UNION ALL '
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = @tableName
  AND DATA_TYPE IN ('char', 'varchar', 'nchar', 'nvarchar', 'text', 'ntext', 'int', 'decimal', 'float', 'datetime'); -- Incluye más tipos

-- Remueve el último 'UNION ALL'
SET @sql = LEFT(@sql, LEN(@sql) - 10);

-- Ejecuta la consulta generada dinámicamente
EXEC sp_executesql @sql;
```

## Notas

- Si no se genera ninguna consulta dinámica, verifica:
  1. Que el nombre de la tabla (`@tableName`) sea correcto.
  2. Que la tabla contenga columnas con tipos de datos compatibles.
- Usa `PRINT @sql` para inspeccionar la consulta generada antes de ejecutarla.

### Depuración

Para depurar posibles problemas:
1. Ejecuta el siguiente fragmento para verificar las columnas disponibles:
    ```sql
    SELECT COLUMN_NAME, DATA_TYPE
    FROM INFORMATION_SCHEMA.COLUMNS
    WHERE TABLE_NAME = 'diskdetails';
    ```
2. Asegúrate de que el script genere una consulta válida usando `PRINT @sql`.




# 

# Detección y Análisis de Workers en SQL Server<a name="7.13"></a>

---

# **Detección y Análisis de Workers en SQL Server**

Este documento presenta un script que permite detectar y analizar el uso de los *workers* en un servidor SQL Server, proporcionando información detallada sobre su estado, actividad y asociación con tareas y solicitudes activas.

---

## **Objetivo**

El objetivo principal del script es:

- Identificar el estado actual de los *workers* en el servidor.
- Analizar su relación con las solicitudes (*requests*) y tareas (*tasks*).
- Ayudar en la optimización y resolución de problemas relacionados con la administración de recursos del servidor.

---

## **Script**

```sql
SELECT s.session_id,
       r.command,
       r.status,
       r.wait_type,
       r.scheduler_id,
       w.worker_address,
       w.is_preemptive,
       w.state,
       t.task_state,
       t.session_id,
       t.exec_context_id,
       t.request_id
FROM sys.dm_exec_sessions AS s
    INNER JOIN sys.dm_exec_requests AS r
        ON s.session_id = r.session_id
    INNER JOIN sys.dm_os_tasks AS t
        ON r.task_address = t.task_address
    INNER JOIN sys.dm_os_workers AS w
        ON t.worker_address = w.worker_address
WHERE s.is_user_process = 0;
```

---

## **Descripción del Código**

### **1. Columnas Seleccionadas**

- **`s.session_id`**: Identificador único de la sesión.
- **`r.command`**: Comando que está ejecutando la solicitud.
- **`r.status`**: Estado actual de la solicitud (Ejecutando, En Espera, etc.).
- **`r.wait_type`**: Tipo de espera asociado a la solicitud.
- **`r.scheduler_id`**: Identificador del programador (*scheduler*) en uso.
- **`w.worker_address`**: Dirección del *worker* en la memoria.
- **`w.is_preemptive`**: Indica si el *worker* está operando en modo preemptivo (fuera del control de SQL Server).
- **`w.state`**: Estado del *worker* (activo, suspendido, etc.).
- **`t.task_state`**: Estado de la tarea asociada.
- **`t.session_id`**: Identificador de la sesión asociada a la tarea.
- **`t.exec_context_id`**: Contexto de ejecución de la tarea.
- **`t.request_id`**: Solicitud asociada a la tarea.

### **2. Fuentes de Datos**

El script utiliza vistas dinámicas de administración (*Dynamic Management Views - DMVs*), que son:

- **`sys.dm_exec_sessions`**: Contiene información sobre las sesiones activas.
- **`sys.dm_exec_requests`**: Detalla las solicitudes activas y sus estados.
- **`sys.dm_os_tasks`**: Información sobre tareas ejecutadas por SQL Server.
- **`sys.dm_os_workers`**: Información sobre los *workers* asignados.

### **3. Filtro Aplicado**

```sql
WHERE s.is_user_process = 0;
```

Este filtro selecciona únicamente procesos del sistema, excluyendo aquellos iniciados por usuarios.

---

## **Explicación de los Workers**

### **¿Qué son los Workers?**

- Los *workers* son unidades internas de ejecución en SQL Server que gestionan tareas como procesamiento de consultas, operaciones de mantenimiento, entre otras.
- Cada *worker* está asociado a un hilo (*thread*) del sistema operativo, y SQL Server administra su programación de manera cooperativa para maximizar el rendimiento.

### **Estados de los Workers**

1. **Activo:** Ejecutando una tarea asignada.
2. **Suspendido:** En espera de recursos o finalización de una operación.
3. **Inactivo:** Disponible para nuevas tareas.

### **Importancia de Monitorear los Workers**

- Los *workers* limitan el nivel de concurrencia del servidor.
- Si todos los *workers* están ocupados, las solicitudes adicionales deben esperar, lo que puede causar latencia o cuellos de botella.

---

## **Cómo Usarlo**

1. Ejecute este script en su instancia de SQL Server.
2. Analice los resultados:
   - Identifique el estado de los *workers*.
   - Verifique posibles bloqueos o tiempos de espera prolongados.
   - Determine si es necesario ajustar la configuración de **max worker threads**.
3. Use esta información para tomar decisiones informadas sobre el escalamiento de recursos o la optimización de cargas de trabajo.

---

## **Notas Importantes**

1. **Configuración de Max Worker Threads:**
   - Puede ajustarse mediante la opción `max worker threads`. El valor predeterminado es adecuado para la mayoría de los escenarios, pero en servidores con alta carga puede ser necesario incrementarlo.

2. **Uso de Recursos:**
   - Un número excesivo de *workers* puede causar sobrecarga en la CPU. Monitoree cuidadosamente su utilización.

---

## **Contribuciones**

Si tienes sugerencias, mejoras o encuentras problemas con este script, siéntete libre de:

- Crear un **Pull Request**.
- Abrir un **Issue** en este repositorio.

---

**Autor:** José Alejandro Jiménez Rosa  


# 

# Monitorización de Sesiones Activas en SQL Server<a name="7.14"></a>

Este script en SQL Server está diseñado para obtener información detallada sobre las sesiones activas en el servidor que están en estado "running". Es especialmente útil para diagnosticar problemas de rendimiento, analizar bloqueos y comprender las características de las consultas en ejecución.

## ¿Qué hace este script?

1. **Identifica sesiones activas**: Obtiene sesiones activas que no corresponden a la conexión actual.
2. **Proporciona detalles sobre las consultas**:
   - Texto de la consulta ejecutada.
   - Nombre del objeto (tabla o vista) relacionado con la consulta.
3. **Muestra métricas de rendimiento**:
   - Lecturas, escrituras y uso de CPU.
   - Tipo y duración de espera.
4. **Bloqueos y dependencias**:
   - Identifica sesiones bloqueadoras.
5. **Información adicional**:
   - Nombre de la base de datos.
   - Nombre del programa que ejecuta la consulta.
   - Nivel de aislamiento de la transacción.

## ¿Cuándo utilizarlo?

Este script es útil para:
- Monitorear la actividad de las consultas en ejecución.
- Diagnosticar problemas de rendimiento relacionados con bloqueos o esperas.
- Obtener información adicional para optimizar consultas o identificar patrones de uso.

## Código SQL

A continuación, copia y pega el siguiente código en tu entorno de SQL Server Management Studio (SSMS) para ejecutarlo:

```sql
SELECT
    es.session_id,
    es.status,
    es.login_name,
    DB_NAME(er.database_id) as database_name,
    es.host_name,
    es.program_name,
    er.blocking_session_id,
    er.command,
    es.reads,
    es.writes,
    es.cpu_time,
    er.wait_type,
    er.wait_time,
    er.last_wait_type,
    er.wait_resource,
    CASE es.transaction_isolation_level 
        WHEN 0 THEN 'Unspecified'
        WHEN 1 THEN 'ReadUncommitted'
        WHEN 2 THEN 'ReadCommitted'
        WHEN 3 THEN 'Repeatable'
        WHEN 4 THEN 'Serializable'
        WHEN 5 THEN 'Snapshot'
    END AS transaction_isolation_level,
    OBJECT_NAME(st.objectid, er.database_id) as object_name,
    SUBSTRING(st.text, er.statement_start_offset / 2,
        (CASE 
            WHEN er.statement_end_offset = -1 THEN LEN(CONVERT(nvarchar(max), st.text)) * 2
            ELSE er.statement_end_offset 
        END - er.statement_start_offset) / 2) AS query_text,
    ph.query_plan
FROM sys.dm_exec_connections ec
LEFT OUTER JOIN sys.dm_exec_sessions es ON ec.session_id = es.session_id
LEFT OUTER JOIN sys.dm_exec_requests er ON ec.connection_id = er.connection_id
OUTER APPLY sys.dm_exec_sql_text(sql_handle) st
OUTER APPLY sys.dm_exec_query_plan(plan_handle) ph
WHERE ec.session_id <> @@SPID
AND es.status = 'running'
ORDER BY es.session_id;
```

## Notas

1. **Permisos requeridos**: Para ejecutar este script, necesitas permisos de administrador en SQL Server o pertenecer al rol `sysadmin`.
2. **Uso responsable**: Este script debe ejecutarse con precaución en entornos de producción, ya que podría impactar el rendimiento si el servidor tiene una alta carga.



# 



# Buscar Caracteres Especiales en una Tabla de SQL Server<a name="7.12"></a>

Este script permite generar dinámicamente una consulta que valida si las columnas de una tabla específica contienen caracteres especiales. La validación incluye varios tipos de datos como `char`, `varchar`, `nchar`, `nvarchar`, `text`, `ntext`, `int`, `decimal`, `float`, y `datetime`.

## Propósito

El propósito de este script es automatizar la validación de datos en una tabla, asegurando que los valores en cada columna cumplan con un formato esperado, como ausencia de caracteres especiales.

## Instrucciones

### 1. Configuración del Script

1. Cambia el nombre de la tabla en la variable `@tableName` por el de la tabla que deseas analizar:
    ```sql
    DECLARE @tableName NVARCHAR(MAX) = 'nombre_de_tu_tabla';
    ```
2. Asegúrate de que la tabla exista en la base de datos actual y contenga columnas con los tipos de datos soportados.

### 2. Tipos de Datos Soportados

El script considera las columnas con los siguientes tipos de datos:
- `char`
- `varchar`
- `nchar`
- `nvarchar`
- `text`
- `ntext`
- `int`
- `decimal`
- `float`
- `datetime`

Puedes modificar esta lista ajustando la cláusula `DATA_TYPE IN` dentro del script.

### 3. Ejecución del Script

Ejecuta el script completo en tu entorno de SQL Server. El script realiza los siguientes pasos:

1. Construye dinámicamente una consulta para analizar cada columna de la tabla.
2. Verifica si los valores en cada columna contienen caracteres especiales.
3. Genera un resultado indicando si cada campo tiene caracteres especiales o no.

### 4. Salida

La salida es una tabla con las siguientes columnas:
- **Campo**: Nombre de la columna analizada.
- **Validación**: Resultado indicando si la columna contiene caracteres especiales (`Contiene caracteres especiales`) o no (`No contiene caracteres especiales`).

## Código

```sql
DECLARE @sql NVARCHAR(MAX) = '';
DECLARE @tableName NVARCHAR(MAX) = 'diskdetails'; -- Cambia por el nombre de tu tabla

-- Construye dinámicamente la consulta
SELECT @sql += 
    'SELECT ''' + COLUMN_NAME + ''' AS Campo, ' +
    'CASE ' +
    'WHEN TRY_CAST([' + COLUMN_NAME + '] AS NVARCHAR(MAX)) LIKE ''%[^a-zA-Z0-9]%'' ' +
    'THEN ''Contiene caracteres especiales'' ' +
    'ELSE ''No contiene caracteres especiales'' END AS Validación ' +
    'FROM [' + @tableName + '] UNION ALL '
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = @tableName
  AND DATA_TYPE IN ('char', 'varchar', 'nchar', 'nvarchar', 'text', 'ntext', 'int', 'decimal', 'float', 'datetime'); -- Incluye más tipos

-- Remueve el último 'UNION ALL'
SET @sql = LEFT(@sql, LEN(@sql) - 10);

-- Ejecuta la consulta generada dinámicamente
EXEC sp_executesql @sql;
```

## Notas

- Si no se genera ninguna consulta dinámica, verifica:
  1. Que el nombre de la tabla (`@tableName`) sea correcto.
  2. Que la tabla contenga columnas con tipos de datos compatibles.
- Usa `PRINT @sql` para inspeccionar la consulta generada antes de ejecutarla.

### Depuración

Para depurar posibles problemas:
1. Ejecuta el siguiente fragmento para verificar las columnas disponibles:
    ```sql
    SELECT COLUMN_NAME, DATA_TYPE
    FROM INFORMATION_SCHEMA.COLUMNS
    WHERE TABLE_NAME = 'diskdetails';
    ```
2. Asegúrate de que el script genere una consulta válida usando `PRINT @sql`.




# 


## Identificar Procedimientos Almacenados con Mayor Tiempo de Duración<a name="identificar-procedimientos-almacenados-con-mayor-tiempo-de-duracion"></a>
![](https://www.revealbi.io/wp-content/uploads/2021/08/what-is-stored-procedure.png)

### Explicación

- `sys.dm_exec_procedure_stats`: Vista de administración dinámica que proporciona estadísticas de ejecución de procedimientos almacenados.
- `qs.total_elapsed_time / qs.execution_count AS avg_elapsed_time`: Calcula el tiempo promedio de ejecución del procedimiento almacenado.
- `qs.total_elapsed_time`: Tiempo total de ejecución de todas las instancias del procedimiento.
- `qs.execution_count`: Número de veces que el procedimiento ha sido ejecutado.
- `qs.creation_time`: Fecha y hora en la que el procedimiento fue compilado.
- `qs.last_execution_time`: Última vez que el procedimiento fue ejecutado.
- `OBJECT_NAME(qs.object_id) AS procedure_name`: Obtiene el nombre del procedimiento almacenado.
- `qs.database_id = DB_ID('nombre_de_tu_base_de_datos')`: Filtra los procedimientos de la base de datos especificada.
- `ORDER BY avg_elapsed_time DESC`: Ordena los resultados por el tiempo promedio de ejecución en orden descendente.

### Consulta SQL

```sql
SELECT
    qs.total_elapsed_time / qs.execution_count AS avg_elapsed_time,
    qs.total_elapsed_time,
    qs.execution_count,
    qs.creation_time,
    qs.last_execution_time,
    OBJECT_NAME(qs.object_id) AS procedure_name
FROM
    sys.dm_exec_procedure_stats AS qs
WHERE
    qs.database_id = DB_ID('nombre_de_tu_base_de_datos')
ORDER BY
    avg_elapsed_time DESC;
```

[⬆ Volver al inicio](#contenido)

---

## Buscar un Procedimiento Almacenado en Todas las Bases de Datos<a name="buscar-un-procedimiento-almacenado-en-todas-las-bases-de-datos"></a>
![](https://amif.mx/wp-content/uploads/grafico-de-base-de-datos-y-procedimientos.jpg)


### Explicación

- `DECLARE @ProcedureName NVARCHAR(128)`: Declara una variable para almacenar el nombre del procedimiento que se desea buscar.
- `DECLARE @SQL NVARCHAR(MAX)`: Declara una variable para construir la consulta dinámica.
- `SELECT @SQL = @SQL + ...`: Construye dinámicamente una consulta para verificar la existencia del procedimiento en cada base de datos.
- `sys.databases`: Contiene la lista de todas las bases de datos en el servidor.
- `sys.procedures`: Tabla del sistema que almacena información sobre los procedimientos almacenados en una base de datos específica.
- `sp_executesql @SQL`: Ejecuta la consulta dinámica construida.

### Consulta SQL

```sql
DECLARE @ProcedureName NVARCHAR(128) = 'nombre_del_procedimiento';
DECLARE @SQL NVARCHAR(MAX);

SET @SQL = '';

SELECT @SQL = @SQL +
    'IF EXISTS (SELECT 1 FROM [' + name + '].sys.procedures WHERE name = ''' + @ProcedureName + ''')
    BEGIN
        PRINT ''Procedimiento encontrado en la base de datos: ' + name + '''
    END
    '
FROM sys.databases;

EXEC sp_executesql @SQL;
```

[⬆ Volver al inicio](#contenido)

---

Este documento puede ser utilizado para futuras referencias en la administración de procedimientos almacenados en SQL Server.





# 
